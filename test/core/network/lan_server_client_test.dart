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
      expect(health.schemaVersion, 10);
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
  });
}
