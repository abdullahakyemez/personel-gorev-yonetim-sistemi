import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/models/network_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkConfig Tests', () {
    test('default values are initialized correctly with empty token and no hardcoded secrets', () {
      const config = NetworkConfig();
      expect(config.mode, NetworkMode.standalone);
      expect(config.serverHost, '127.0.0.1');
      expect(config.serverPort, 8085);
      expect(config.authToken, '');
      expect(config.adminToken, isNull);
      expect(config.autoSyncEnabled, isTrue);
      expect(config.syncIntervalSeconds, 15);
      expect(config.lastSyncTime, isNull);
    });

    test('generateSecureToken generates random secure token of at least 32 characters', () {
      final token1 = NetworkConfig.generateSecureToken();
      final token2 = NetworkConfig.generateSecureToken();
      final customLengthToken = NetworkConfig.generateSecureToken(48);

      expect(token1.length, greaterThanOrEqualTo(32));
      expect(token2.length, greaterThanOrEqualTo(32));
      expect(customLengthToken.length, equals(48));
      expect(token1, isNot(equals(token2)));
    });

    test('NetworkMode.fromString handles valid and invalid strings', () {
      expect(NetworkMode.fromString('standalone'), NetworkMode.standalone);
      expect(NetworkMode.fromString('server'), NetworkMode.server);
      expect(NetworkMode.fromString('client'), NetworkMode.client);
      expect(NetworkMode.fromString('unknown'), NetworkMode.standalone);
      expect(NetworkMode.fromString(null), NetworkMode.standalone);
    });

    test('toJson and fromJson work bidirectionally including adminToken', () {
      final now = DateTime(2026, 9, 17, 16, 30);
      final config = NetworkConfig(
        mode: NetworkMode.client,
        serverHost: '192.168.1.100',
        serverPort: 9000,
        authToken: 'custom-secret-key-32-chars-long!',
        adminToken: 'admin-secret-token-32-chars-long!',
        autoSyncEnabled: false,
        syncIntervalSeconds: 30,
        lastSyncTime: now,
      );

      final json = config.toJson();
      final fromJson = NetworkConfig.fromJson(json);

      expect(fromJson.mode, NetworkMode.client);
      expect(fromJson.serverHost, '192.168.1.100');
      expect(fromJson.serverPort, 9000);
      expect(fromJson.authToken, 'custom-secret-key-32-chars-long!');
      expect(fromJson.adminToken, 'admin-secret-token-32-chars-long!');
      expect(fromJson.autoSyncEnabled, isFalse);
      expect(fromJson.syncIntervalSeconds, 30);
      expect(fromJson.lastSyncTime, now);
    });

    test('loadFromPrefs generates and persists secure token when none exists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final config = NetworkConfig.loadFromPrefs(prefs);

      expect(config.authToken, isNotEmpty);
      expect(config.authToken.length, greaterThanOrEqualTo(32));
      expect(prefs.getString('pgys_network_token'), equals(config.authToken));
    });

    test('loadFromPrefs preserves existing token if present in preferences', () async {
      SharedPreferences.setMockInitialValues({
        'pgys_network_token': 'my-persisted-token-12345',
        'pgys_network_adminToken': 'my-persisted-admin-token-67890',
      });
      final prefs = await SharedPreferences.getInstance();

      final config = NetworkConfig.loadFromPrefs(prefs);

      expect(config.authToken, equals('my-persisted-token-12345'));
      expect(config.adminToken, equals('my-persisted-admin-token-67890'));
    });

    test('saveToPrefs and loadFromPrefs work with SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final now = DateTime(2026, 9, 17, 14, 20);
      final config = NetworkConfig(
        mode: NetworkMode.server,
        serverHost: '10.0.0.1',
        serverPort: 8080,
        authToken: 'my-token',
        adminToken: 'my-admin-token',
        autoSyncEnabled: true,
        syncIntervalSeconds: 20,
        lastSyncTime: now,
      );

      await config.saveToPrefs(prefs);
      final loaded = NetworkConfig.loadFromPrefs(prefs);

      expect(loaded.mode, NetworkMode.server);
      expect(loaded.serverHost, '10.0.0.1');
      expect(loaded.serverPort, 8080);
      expect(loaded.authToken, 'my-token');
      expect(loaded.adminToken, 'my-admin-token');
      expect(loaded.autoSyncEnabled, isTrue);
      expect(loaded.syncIntervalSeconds, 20);
      expect(loaded.lastSyncTime, now);
    });

    test('copyWith updates only specified fields', () {
      const original = NetworkConfig(mode: NetworkMode.standalone, serverPort: 8085);
      final updated = original.copyWith(
        mode: NetworkMode.server,
        serverPort: 8090,
        adminToken: 'new-admin-token',
      );

      expect(updated.mode, NetworkMode.server);
      expect(updated.serverPort, 8090);
      expect(updated.serverHost, original.serverHost);
      expect(updated.authToken, original.authToken);
      expect(updated.adminToken, 'new-admin-token');
    });
  });
}
