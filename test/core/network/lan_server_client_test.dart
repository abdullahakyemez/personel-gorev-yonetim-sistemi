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
  const testToken = 'test-token-123';

  setUp(() async {
    serverDb = AppDatabase(NativeDatabase.memory());
    clientDb = AppDatabase(NativeDatabase.memory());
    server = LanServer(serverDb);
    client = LanClient();
    syncService = LanSyncService(
      database: clientDb,
      server: server,
      client: client,
    );

    // Bind to port 0 (ephemeral free port)
    final started = await server.start(port: 0, authToken: testToken);
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

    test('push and fetch sync data roundtrip works seamlessly', () async {
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
