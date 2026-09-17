import 'package:shared_preferences/shared_preferences.dart';

enum NetworkMode {
  standalone('Tek Bilgisayar (Yerel Mod)'),
  server('Merkez Sunucu Modu (Ana Makine)'),
  client('İstemci Modu (Merkeze Bağlı)');

  final String label;
  const NetworkMode(this.label);

  static NetworkMode fromString(String? val) {
    if (val == null) return NetworkMode.standalone;
    return NetworkMode.values.firstWhere(
      (m) => m.name == val,
      orElse: () => NetworkMode.standalone,
    );
  }
}

class NetworkConfig {
  final NetworkMode mode;
  final String serverHost;
  final int serverPort;
  final String authToken;
  final bool autoSyncEnabled;
  final int syncIntervalSeconds;
  final DateTime? lastSyncTime;

  const NetworkConfig({
    this.mode = NetworkMode.standalone,
    this.serverHost = '127.0.0.1',
    this.serverPort = 8085,
    this.authToken = 'pgys-lan-secret',
    this.autoSyncEnabled = true,
    this.syncIntervalSeconds = 15,
    this.lastSyncTime,
  });

  NetworkConfig copyWith({
    NetworkMode? mode,
    String? serverHost,
    int? serverPort,
    String? authToken,
    bool? autoSyncEnabled,
    int? syncIntervalSeconds,
    DateTime? lastSyncTime,
  }) {
    return NetworkConfig(
      mode: mode ?? this.mode,
      serverHost: serverHost ?? this.serverHost,
      serverPort: serverPort ?? this.serverPort,
      authToken: authToken ?? this.authToken,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'serverHost': serverHost,
      'serverPort': serverPort,
      'authToken': authToken,
      'autoSyncEnabled': autoSyncEnabled,
      'syncIntervalSeconds': syncIntervalSeconds,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
    };
  }

  factory NetworkConfig.fromJson(Map<String, dynamic> json) {
    return NetworkConfig(
      mode: NetworkMode.fromString(json['mode'] as String?),
      serverHost: json['serverHost'] as String? ?? '127.0.0.1',
      serverPort: json['serverPort'] as int? ?? 8085,
      authToken: json['authToken'] as String? ?? 'pgys-lan-secret',
      autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? true,
      syncIntervalSeconds: json['syncIntervalSeconds'] as int? ?? 15,
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.tryParse(json['lastSyncTime'] as String)
          : null,
    );
  }

  static const _prefPrefix = 'pgys_network_';

  static NetworkConfig loadFromPrefs(SharedPreferences prefs) {
    final modeStr = prefs.getString('${_prefPrefix}mode');
    final host = prefs.getString('${_prefPrefix}host') ?? '127.0.0.1';
    final port = prefs.getInt('${_prefPrefix}port') ?? 8085;
    final token = prefs.getString('${_prefPrefix}token') ?? 'pgys-lan-secret';
    final autoSync = prefs.getBool('${_prefPrefix}autoSync') ?? true;
    final interval = prefs.getInt('${_prefPrefix}interval') ?? 15;
    final lastSyncStr = prefs.getString('${_prefPrefix}lastSync');

    return NetworkConfig(
      mode: NetworkMode.fromString(modeStr),
      serverHost: host,
      serverPort: port,
      authToken: token,
      autoSyncEnabled: autoSync,
      syncIntervalSeconds: interval,
      lastSyncTime: lastSyncStr != null ? DateTime.tryParse(lastSyncStr) : null,
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString('${_prefPrefix}mode', mode.name);
    await prefs.setString('${_prefPrefix}host', serverHost);
    await prefs.setInt('${_prefPrefix}port', serverPort);
    await prefs.setString('${_prefPrefix}token', authToken);
    await prefs.setBool('${_prefPrefix}autoSync', autoSyncEnabled);
    await prefs.setInt('${_prefPrefix}interval', syncIntervalSeconds);
    if (lastSyncTime != null) {
      await prefs.setString('${_prefPrefix}lastSync', lastSyncTime!.toIso8601String());
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          serverHost == other.serverHost &&
          serverPort == other.serverPort &&
          authToken == other.authToken &&
          autoSyncEnabled == other.autoSyncEnabled &&
          syncIntervalSeconds == other.syncIntervalSeconds &&
          lastSyncTime == other.lastSyncTime;

  @override
  int get hashCode =>
      mode.hashCode ^
      serverHost.hashCode ^
      serverPort.hashCode ^
      authToken.hashCode ^
      autoSyncEnabled.hashCode ^
      syncIntervalSeconds.hashCode ^
      lastSyncTime.hashCode;
}
