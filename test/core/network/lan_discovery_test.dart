import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_discovery_service.dart';

void main() {
  group('LanDiscoveryService Tests', () {
    const testDiscoveryPort = 40411;
    const testServerPort = 9099;

    test('LanDiscoveryAdvertiser and LanDiscoveryScanner discover local server via UDP', () async {
      final advertiser = LanDiscoveryAdvertiser(
        serverPort: testServerPort,
        serverName: 'PGYS Test Server',
        discoveryPort: testDiscoveryPort,
      );

      final started = await advertiser.start();
      expect(started, isTrue);
      expect(advertiser.isRunning, isTrue);

      try {
        final discovered = await LanDiscoveryScanner.scanForServers(
          timeout: const Duration(milliseconds: 600),
          targetPort: testDiscoveryPort,
        );

        expect(discovered, isNotEmpty);
        final found = discovered.firstWhere((s) => s.port == testServerPort);
        expect(found.serverName, 'PGYS Test Server');
        expect(found.ip, isNotEmpty);
      } finally {
        advertiser.stop();
        expect(advertiser.isRunning, isFalse);
      }
    });
  });
}
