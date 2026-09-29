import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/models/lan_sync_payload.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_client.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_server.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = null;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase serverDb;
  late AppDatabase clientDb;
  late LanServer server;
  late LanClient client;
  late LanSyncService syncService;
  late int boundPort;
  const testToken = 'test-token-1234567890123456789012';
  const testAdminToken = 'admin-token-12345678901234567890';

  setUp(() async {
    serverDb = AppDatabase(NativeDatabase.memory());
    clientDb = AppDatabase(NativeDatabase.memory());
    server = LanServer(serverDb, adminToken: testAdminToken);
    client = LanClient();
    syncService = LanSyncService(
      database: clientDb,
      server: server,
      client: client,
    );

    // Bind to port 0 (ephemeral free port)
    final started = await server.start(
      port: 0,
      authToken: testToken,
      adminToken: testAdminToken,
    );
    expect(started, isTrue);
    boundPort = server.port!;
    expect(boundPort, greaterThan(0));
  });

  tearDown(() async {
    await server.stop();
    client.close();
    await serverDb.close();
    await clientDb.close();
  });

  group('LanServer & LanClient Integration Tests', () {
    test('server reports running state and closes gracefully', () async {
      expect(server.isRunning, isTrue);
      await server.stop();
      expect(server.isRunning, isFalse);
    });

    test('LanServer.constantTimeEquals accurately compares tokens regardless of timing', () {
      expect(LanServer.constantTimeEquals('exact-secret', 'exact-secret'), isTrue);
      expect(LanServer.constantTimeEquals('exact-secret', 'exact-secreT'), isFalse);
      expect(LanServer.constantTimeEquals('exact-secret', 'exact'), isFalse);
      expect(LanServer.constantTimeEquals('exact', 'exact-secret'), isFalse);
      expect(LanServer.constantTimeEquals('', 'exact-secret'), isFalse);
      expect(LanServer.constantTimeEquals('exact-secret', ''), isFalse);
      expect(LanServer.constantTimeEquals('', ''), isTrue);
    });

    test('client checkHealth returns success with correct server metadata', () async {
      final health = await client.checkHealth(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );

      expect(health.isSuccess, isTrue);
      expect(health.appName, 'PGYS');
      expect(health.schemaVersion, serverDb.schemaVersion);
      expect(health.pingMs, greaterThanOrEqualTo(0));
    });

    test('client checkHealth fails with invalid token (401 Unauthorized)', () async {
      final health = await client.checkHealth(
        host: '127.0.0.1',
        port: boundPort,
        token: 'wrong-token',
      );

      expect(health.isSuccess, isFalse);
      expect(health.errorMessage, contains('Yetkisiz'));
    });

    test('push and fetch sync data roundtrip works seamlessly for standard tables', () async {
      // 1. Push a test personnel record from client payload to server
      final payload = LanSyncPayload(
        timestamp: DateTime.now(),
        personnel: [
          {
            'id': 1001,
            'registry_number': 'TEST999',
            'full_name': 'Ağ Personeli',
            'rank': 'Polis Memuru',
            'title': 'Memur',
            'branch': 'Bilgi İşlem',
            'department': 'Yazılım',
            'start_date': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'phone': '5551234567',
            'email': 'ag@test.com',
            'address': 'Merkez Kampüs',
            'status': 'duty',
          }
        ],
      );

      final pushed = await client.pushSyncData(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
        payload: payload,
      );
      expect(pushed, isTrue);

      // 2. Fetch all tables from server
      final fetched = await client.fetchSyncData(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );

      expect(fetched.personnel.isNotEmpty, isTrue);
      final found = fetched.personnel.firstWhere(
        (p) => p['registry_number'] == 'TEST999',
      );
      expect(found['full_name'], 'Ağ Personeli');
      expect(found['branch'], 'Bilgi İşlem');
    });

    test('pushing user_table without admin token is rejected with 403 Forbidden', () async {
      final userPayload = LanSyncPayload(
        timestamp: DateTime.now(),
        users: [
          {
            'id': 501,
            'username': 'admin_attacker',
            'password_hash': 'injected_hash',
            'salt': 'salt123',
            'full_name': 'Hacker',
            'role': 'admin',
          }
        ],
      );

      // 1. Using standard client (only sends regular X-PGYS-Token)
      final clientPushResult = await client.pushSyncData(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
        payload: userPayload,
      );
      expect(clientPushResult, isFalse);

      // 2. Using raw HTTP request without X-PGYS-Admin-Token to verify HTTP 403 status
      final rawClient = HttpClient();
      try {
        final req = await rawClient.post('127.0.0.1', boundPort, '/api/sync/push');
        req.headers.set('X-PGYS-Token', testToken);
        req.headers.set('Content-Type', 'application/json; charset=utf-8');
        req.write(jsonEncode(userPayload.toJson()));
        final resp = await req.close();
        expect(resp.statusCode, equals(HttpStatus.forbidden));

        final body = await utf8.decoder.bind(resp).join();
        expect(body, contains('user_table'));
      } finally {
        rawClient.close(force: true);
      }

      // Verify server database was not modified
      final userRows = await serverDb.customSelect("SELECT * FROM user_table WHERE username = 'admin_attacker';").get();
      expect(userRows, isEmpty);
    });

    test('pushing user_table with invalid admin token is rejected with 403 Forbidden', () async {
      final userPayload = LanSyncPayload(
        timestamp: DateTime.now(),
        users: [
          {
            'id': 502,
            'username': 'fake_admin',
            'password_hash': 'fake_hash',
            'salt': 'fake_salt',
            'full_name': 'Fake Admin',
            'role': 'admin',
          }
        ],
      );

      final rawClient = HttpClient();
      try {
        final req = await rawClient.post('127.0.0.1', boundPort, '/api/sync/push');
        req.headers.set('X-PGYS-Token', testToken);
        req.headers.set('X-PGYS-Admin-Token', 'wrong-admin-token');
        req.headers.set('Content-Type', 'application/json; charset=utf-8');
        req.write(jsonEncode(userPayload.toJson()));
        final resp = await req.close();
        expect(resp.statusCode, equals(HttpStatus.forbidden));
      } finally {
        rawClient.close(force: true);
      }

      final userRows = await serverDb.customSelect("SELECT * FROM user_table WHERE username = 'fake_admin';").get();
      expect(userRows, isEmpty);
    });

    test('pushing user_table with valid admin token succeeds and updates user_table', () async {
      final nowTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final userPayload = LanSyncPayload(
        timestamp: DateTime.now(),
        users: [
          {
            'id': 503,
            'username': 'valid_admin',
            'password_hash': 'valid_hash_abc',
            'salt': 'salt_xyz',
            'full_name': 'Valid Admin',
            'role': 'superadmin',
            'created_at': nowTimestamp,
          }
        ],
      );

      final rawClient = HttpClient();
      try {
        final req = await rawClient.post('127.0.0.1', boundPort, '/api/sync/push');
        req.headers.set('X-PGYS-Token', testToken);
        req.headers.set('X-PGYS-Admin-Token', testAdminToken);
        req.headers.set('Content-Type', 'application/json; charset=utf-8');
        req.write(jsonEncode(userPayload.toJson()));
        final resp = await req.close();
        expect(resp.statusCode, equals(HttpStatus.ok));

        final body = await utf8.decoder.bind(resp).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        expect(json['success'], isTrue);
      } finally {
        rawClient.close(force: true);
      }

      // Verify user is successfully saved in server database
      final userRows = await serverDb.customSelect("SELECT * FROM user_table WHERE username = 'valid_admin';").get();
      expect(userRows.length, equals(1));
      expect(userRows.first.read<String>('full_name'), equals('Valid Admin'));
      expect(userRows.first.read<String>('password_hash'), equals('valid_hash_abc'));
    });

    test('LanSyncService pullFromServer syncs server data into local database', () async {
      final nowTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // 1. Insert record into server directly
      await serverDb.customStatement(
        "INSERT INTO personnel_table (id, registry_number, full_name, rank, title, branch, department, start_date, phone, email, address, status) "
        "VALUES (2001, 'REG2001', 'Sunucu Personeli', 'Başkomiser', 'Büro Amiri', 'Asayiş', 'Merkez', $nowTimestamp, '5559876543', 'amir@test.com', 'Ankara', 'duty');",
      );

      // 2. Verify client database does not have this record yet
      final beforeRows = await clientDb.customSelect(
        "SELECT * FROM personnel_table WHERE registry_number = 'REG2001';",
      ).get();
      expect(beforeRows, isEmpty);

      // 3. Client pulls from server
      final synced = await syncService.pullFromServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      expect(synced, isTrue);

      // 4. Verify client database now has the synced record
      final afterRows = await clientDb.customSelect(
        "SELECT * FROM personnel_table WHERE registry_number = 'REG2001';",
      ).get();
      expect(afterRows.length, 1);
      expect(afterRows.first.read<String>('full_name'), 'Sunucu Personeli');
    });

    test('server responds with security headers (nosniff, DENY)', () async {
      final rawClient = HttpClient();
      try {
        final req = await rawClient.get('127.0.0.1', boundPort, '/api/health');
        req.headers.set('X-PGYS-Token', testToken);
        final resp = await req.close();
        expect(resp.statusCode, equals(HttpStatus.ok));
        expect(resp.headers.value('x-content-type-options'), equals('nosniff'));
        expect(resp.headers.value('x-frame-options'), equals('DENY'));
      } finally {
        rawClient.close(force: true);
      }
    });

    test('rate limiting triggers 429 Too Many Requests after 10 failed auth attempts', () async {
      final rawClient = HttpClient();
      try {
        // Send 10 failed attempts
        for (var i = 0; i < 10; i++) {
          final req = await rawClient.get('127.0.0.1', boundPort, '/api/health');
          req.headers.set('X-PGYS-Token', 'wrong-token-$i');
          final resp = await req.close();
          expect(resp.statusCode, equals(HttpStatus.unauthorized));
          await resp.drain();
        }

        // 11th attempt should trigger 429 Too Many Requests
        final reqBlocked = await rawClient.get('127.0.0.1', boundPort, '/api/health');
        reqBlocked.headers.set('X-PGYS-Token', testToken); // Even with correct token, IP is throttled
        final respBlocked = await reqBlocked.close();
        expect(respBlocked.statusCode, equals(HttpStatus.tooManyRequests));
        final body = await utf8.decoder.bind(respBlocked).join();
        expect(body, contains('Çok fazla başarısız'));
      } finally {
        rawClient.close(force: true);
      }
    });

    test('LanSyncService pushToServer successfully pushes client tasks to server', () async {
      // 1. Insert a task into clientDb
      await clientDb.customStatement(
        "INSERT INTO task_table (id, title, description, status, start_date, end_date) VALUES ('task_client_1', 'Devriye Görevi', 'Meydan devriyesi', 'pending', 1700000000, 1700010000);",
      );

      // 2. Push to server
      final pushed = await syncService.pushToServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      expect(pushed, isTrue);

      // 3. Verify serverDb received the task
      final serverTasks = await serverDb.customSelect(
        "SELECT * FROM task_table WHERE id = 'task_client_1';",
      ).get();
      expect(serverTasks.length, 1);
      expect(serverTasks.first.read<String>('title'), 'Devriye Görevi');
    });

    test('deletions are synchronized and deleted records are not resurrected', () async {
      // 1. Insert a task on server
      await serverDb.customStatement(
        "INSERT INTO task_table (id, title, description, status, start_date, end_date) VALUES ('task_del_1', 'Silinecek Görev', 'Açıklama', 'completed', 1700000000, 1700010000);",
      );

      // 2. Client pulls task
      await syncService.pullFromServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      final clientCheck = await clientDb.customSelect("SELECT * FROM task_table WHERE id = 'task_del_1';").get();
      expect(clientCheck.length, 1);

      // 3. Client deletes task and records tombstone
      await clientDb.customStatement("DELETE FROM task_table WHERE id = 'task_del_1';");
      await clientDb.customStatement(
        "INSERT INTO sync_deletions_table (id, table_name, record_id, deleted_at) VALUES ('task_task_del_1', 'task_table', 'task_del_1', 1700050000);",
      );

      // 4. Client pushes to server
      final pushSuccess = await syncService.pushToServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      expect(pushSuccess, isTrue);

      // 5. Server should now have deleted task_del_1
      final serverCheck = await serverDb.customSelect("SELECT * FROM task_table WHERE id = 'task_del_1';").get();
      expect(serverCheck, isEmpty);

      // 6. Client pulls again; task_del_1 should NOT be resurrected
      await syncService.pullFromServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      final clientCheckAfter = await clientDb.customSelect("SELECT * FROM task_table WHERE id = 'task_del_1';").get();
      expect(clientCheckAfter, isEmpty);
    });

    test('personnel sync with same registry number updates without duplicating or overwriting ID', () async {
      // 1. Server has Ali with registry '1001' and id 1
      await serverDb.customStatement(
        "INSERT INTO personnel_table (id, registry_number, full_name, rank, title, branch, department, start_date, phone, email, address, status) VALUES (1, '1001', 'Ali Yılmaz', 'Polis Memuru', 'Memur', 'Asayiş', 'A Büro', 1700000000, '555111', 'ali@test.com', 'Adres', 'duty');",
      );

      // 2. Client has updated details for '1001' with a different local id (e.g. 5)
      await clientDb.customStatement(
        "INSERT INTO personnel_table (id, registry_number, full_name, rank, title, branch, department, start_date, phone, email, address, status) VALUES (5, '1001', 'Ali Yılmaz Güncel', 'Kıdemli Başpolis', 'Memur', 'Trafik', 'B Büro', 1700000000, '555111', 'ali@test.com', 'Adres', 'duty');",
      );

      // 3. Client pushes to server
      final pushSuccess = await syncService.pushToServer(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      expect(pushSuccess, isTrue);

      // 4. Server row should have maintained id=1 but updated full_name and branch
      final serverRows = await serverDb.customSelect("SELECT * FROM personnel_table WHERE registry_number = '1001';").get();
      expect(serverRows.length, 1);
      expect(serverRows.first.read<int>('id'), 1);
      expect(serverRows.first.read<String>('full_name'), 'Ali Yılmaz Güncel');
      expect(serverRows.first.read<String>('branch'), 'Trafik');
    });

    test('WebSocket connects successfully with valid token and receives broadcast', () async {
      final ws = await client.connectWebSocket(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      for (var i = 0; i < 40 && server.connectedClientCount < 1; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }
      expect(server.connectedClientCount, 1);

      final receivedMessages = <Map<String, dynamic>>[];
      final sub = ws.listen((msg) {
        receivedMessages.add(jsonDecode(msg.toString()) as Map<String, dynamic>);
      });

      // Broadcast an event from server
      final sentCount = server.broadcast('test_event', data: {'hello': 'world'});
      expect(sentCount, 1);

      // Wait for packet delivery
      for (var i = 0; i < 40 && receivedMessages.isEmpty; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }
      expect(receivedMessages.length, 1);
      expect(receivedMessages.first['type'], 'test_event');
      expect(receivedMessages.first['data']['hello'], 'world');

      await sub.cancel();
      await ws.close();
    });

    test('WebSocket rejects connection with invalid token', () async {
      expect(
        () => client.connectWebSocket(
          host: '127.0.0.1',
          port: boundPort,
          token: 'wrong-token',
        ),
        throwsA(isA<WebSocketException>()),
      );
    });

    test('server.broadcast excludes sender client ID', () async {
      final client1 = LanClient(null, 'client_A');
      final client2 = LanClient(null, 'client_B');

      final ws1 = await client1.connectWebSocket(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      final ws2 = await client2.connectWebSocket(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      for (var i = 0; i < 40 && server.connectedClientCount < 2; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }

      expect(server.connectedClientCount, 2);

      final msgs1 = <String>[];
      final msgs2 = <String>[];

      final sub1 = ws1.listen((msg) => msgs1.add(msg.toString()));
      final sub2 = ws2.listen((msg) => msgs2.add(msg.toString()));

      // Broadcast excluding client_A
      final sentCount = server.broadcast(
        'data_changed',
        data: {'source': 'client_A'},
        excludeClientId: 'client_A',
      );

      expect(sentCount, 1);

      for (var i = 0; i < 40 && msgs2.isEmpty; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }

      expect(msgs1, isEmpty);
      expect(msgs2.length, 1);
      expect(msgs2.first, contains('client_A'));

      await sub1.cancel();
      await sub2.cancel();
      await ws1.close();
      await ws2.close();
      client1.close();
      client2.close();
    });

    test('pushSyncData automatically triggers data_changed WebSocket broadcast to peers', () async {
      final peerClient = LanClient(null, 'peer_client');
      final peerWs = await peerClient.connectWebSocket(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
      );
      for (var i = 0; i < 40 && server.connectedClientCount < 1; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }

      final receivedBroadcasts = <Map<String, dynamic>>[];
      final sub = peerWs.listen((msg) {
        receivedBroadcasts.add(jsonDecode(msg.toString()) as Map<String, dynamic>);
      });


      // Prepare a task on client to push
      final pushPayload = LanSyncPayload(
        timestamp: DateTime.now(),
        tasks: [
          {
            'id': 'ws_task_1',
            'title': 'WebSocket Broadcast Task',
            'description': 'Test description',
            'start_date': 1700000000,
            'end_date': 1700086400,
            'status': 'pending',
          }

        ],
      );

      final pushSuccess = await client.pushSyncData(
        host: '127.0.0.1',
        port: boundPort,
        token: testToken,
        payload: pushPayload,
      );
      expect(pushSuccess, isTrue);

      for (var i = 0; i < 40 && receivedBroadcasts.isEmpty; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
      }

      expect(receivedBroadcasts.length, 1);
      expect(receivedBroadcasts.first['type'], 'data_changed');
      expect(receivedBroadcasts.first['data']['source'], 'client_push');

      await sub.cancel();
      await peerWs.close();
      peerClient.close();
    });


    test('LanSyncService emits local change events on notifyDataChanged', () async {
      final events = <String>[];
      final sub = LanSyncService.onLocalChange.listen((e) => events.add(e));

      LanSyncService.notifyDataChanged('test_mutation');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(events, contains('test_mutation'));
      await sub.cancel();
    });
  });
}

