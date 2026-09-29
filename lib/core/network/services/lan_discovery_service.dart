import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Keşfedilen Merkez Sunucu Bilgisi
class DiscoveredServer {
  final String ip;
  final int port;
  final String hostname;
  final String serverName;
  final String? version;

  const DiscoveredServer({
    required this.ip,
    required this.port,
    required this.hostname,
    required this.serverName,
    this.version,
  });

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'port': port,
        'hostname': hostname,
        'serverName': serverName,
        'version': version,
      };

  factory DiscoveredServer.fromJson(Map<String, dynamic> json, String senderIp) {
    return DiscoveredServer(
      ip: senderIp,
      port: json['port'] as int? ?? 8085,
      hostname: json['hostname'] as String? ?? '',
      serverName: json['serverName'] as String? ?? 'PGYS Merkez Sunucu',
      version: json['version'] as String?,
    );
  }

  @override
  String toString() => '$serverName ($hostname - $ip:$port)';
}

/// Merkez Sunucunun Yerel Ağda (LAN) Kendisini Duyurması (UDP Broadcast Listener)
class LanDiscoveryAdvertiser {
  static const int defaultDiscoveryPort = 40410;
  static const String probeMagic = 'PGYS_DISCOVERY_PROBE';
  static const String ackMagic = 'PGYS_DISCOVERY_ACK';

  final int serverPort;
  final String serverName;
  final int discoveryPort;

  RawDatagramSocket? _socket;
  bool _running = false;

  LanDiscoveryAdvertiser({
    required this.serverPort,
    this.serverName = 'PGYS Merkez Sunucu',
    this.discoveryPort = defaultDiscoveryPort,
  });

  bool get isRunning => _running;

  Future<bool> start() async {
    if (_running) return true;

    try {
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        discoveryPort,
        reuseAddress: true,
        reusePort: false,
      );
      _socket?.broadcastEnabled = true;
      _running = true;

      _socket?.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _socket?.receive();
          if (datagram != null) {
            try {
              final message = utf8.decode(datagram.data).trim();
              if (message == probeMagic) {
                final responsePayload = jsonEncode({
                  'magic': ackMagic,
                  'port': serverPort,
                  'hostname': Platform.localHostname,
                  'serverName': serverName,
                  'version': '1.0.4',
                });
                final responseBytes = utf8.encode(responsePayload);
                _socket?.send(responseBytes, datagram.address, datagram.port);
              }
            } catch (_) {
              // Hatalı paketler yoksayılır
            }
          }
        }
      });
      return true;
    } catch (_) {
      // Port kullanımda veya güvenlik duvarı izin vermiyor olabilir
      _running = false;
      return false;
    }
  }

  void stop() {
    _running = false;
    _socket?.close();
    _socket = null;
  }
}

/// İstemcilerin (Client) Ağdaki Merkez Sunucuları Araması (UDP Broadcast Scanner)
class LanDiscoveryScanner {
  static const int defaultDiscoveryPort = 40410;
  static const String probeMagic = 'PGYS_DISCOVERY_PROBE';
  static const String ackMagic = 'PGYS_DISCOVERY_ACK';

  /// Yerel ağda yayın yaparak çalışan PGYS Merkez Sunucularını arar
  static Future<List<DiscoveredServer>> scanForServers({
    Duration timeout = const Duration(milliseconds: 1500),
    int targetPort = defaultDiscoveryPort,
  }) async {
    final discoveredServers = <String, DiscoveredServer>{};
    RawDatagramSocket? socket;

    try {
      socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0, // İşletim sisteminden rastgele boş port al
        reuseAddress: true,
      );
      socket.broadcastEnabled = true;

      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket?.receive();
          if (datagram != null) {
            try {
              final text = utf8.decode(datagram.data);
              final json = jsonDecode(text);
              if (json is Map<String, dynamic> && json['magic'] == ackMagic) {
                final senderIp = datagram.address.address;
                final server = DiscoveredServer.fromJson(json, senderIp);
                final key = '${server.ip}:${server.port}';
                discoveredServers[key] = server;
              }
            } catch (_) {
              // Geçersiz JSON veya yabancı paket
            }
          }
        }
      });

      final probeBytes = utf8.encode(probeMagic);

      // 1. Genel yayın adresine (255.255.255.255) paket gönder
      try {
        socket.send(probeBytes, InternetAddress('255.255.255.255'), targetPort);
      } catch (_) {}

      // 2. Yerel ağ kartlarının broadcast adreslerine de paket gönder
      try {
        final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
        for (final interface in interfaces) {
          for (final addr in interface.addresses) {
            final parts = addr.address.split('.');
            if (parts.length == 4) {
              final subnetBroadcast = '${parts[0]}.${parts[1]}.${parts[2]}.255';
              try {
                socket.send(probeBytes, InternetAddress(subnetBroadcast), targetPort);
              } catch (_) {}
            }
          }
        }
      } catch (_) {}

      // Yanıtların gelmesi için kısa bir süre bekle
      await Future.delayed(timeout);
    } catch (_) {
      // Soket oluşturma hatası
    } finally {
      socket?.close();
    }

    return discoveredServers.values.toList();
  }
}
