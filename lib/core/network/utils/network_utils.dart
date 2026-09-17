import 'dart:io';

class NetworkUtils {
  NetworkUtils._();

  /// Returns the non-loopback IPv4 addresses of the current device.
  /// Used by server mode to show host machine IP address (e.g. 192.168.1.50).
  static Future<List<String>> getLocalIpv4Addresses() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      final addresses = <String>{};
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          if (!address.isLoopback && address.type == InternetAddressType.IPv4) {
            addresses.add(address.address);
          }
        }
      }

      if (addresses.isEmpty) {
        return ['127.0.0.1'];
      }
      return addresses.toList();
    } catch (_) {
      return ['127.0.0.1'];
    }
  }

  /// Formats host and port into a standard HTTP URL base.
  static String formatBaseUrl(String host, int port) {
    var cleanHost = host.trim();
    if (cleanHost.startsWith('http://')) {
      cleanHost = cleanHost.substring(7);
    } else if (cleanHost.startsWith('https://')) {
      cleanHost = cleanHost.substring(8);
    }
    if (cleanHost.contains(':')) {
      cleanHost = cleanHost.split(':').first;
    }
    return 'http://$cleanHost:$port';
  }
}
