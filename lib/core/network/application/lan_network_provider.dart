import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/service_locator.dart';
import '../models/network_config.dart';
import '../services/lan_client.dart';
import '../services/lan_server.dart';
import '../services/lan_sync_service.dart';
import '../utils/network_utils.dart';

enum LanConnectionStatus {
  idle,
  connecting,
  connected,
  disconnected,
  error,
}

class LanNetworkState {
  final NetworkConfig config;
  final bool isServerRunning;
  final List<String> serverLocalIps;
  final LanConnectionStatus clientStatus;
  final int? pingMs;
  final String? statusMessage;
  final bool isSyncing;

  const LanNetworkState({
    required this.config,
    this.isServerRunning = false,
    this.serverLocalIps = const [],
    this.clientStatus = LanConnectionStatus.idle,
    this.pingMs,
    this.statusMessage,
    this.isSyncing = false,
  });

  LanNetworkState copyWith({
    NetworkConfig? config,
    bool? isServerRunning,
    List<String>? serverLocalIps,
    LanConnectionStatus? clientStatus,
    int? pingMs,
    String? statusMessage,
    bool? isSyncing,
  }) {
    return LanNetworkState(
      config: config ?? this.config,
      isServerRunning: isServerRunning ?? this.isServerRunning,
      serverLocalIps: serverLocalIps ?? this.serverLocalIps,
      clientStatus: clientStatus ?? this.clientStatus,
      pingMs: pingMs ?? this.pingMs,
      statusMessage: statusMessage ?? this.statusMessage,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class LanNetworkNotifier extends Notifier<LanNetworkState> {
  Timer? _syncTimer;

  LanServer? get _server => getIt.isRegistered<LanServer>() ? getIt<LanServer>() : null;
  LanClient? get _client => getIt.isRegistered<LanClient>() ? getIt<LanClient>() : null;
  LanSyncService? get _syncService => getIt.isRegistered<LanSyncService>() ? getIt<LanSyncService>() : null;
  SharedPreferences? get _prefs => getIt.isRegistered<SharedPreferences>() ? getIt<SharedPreferences>() : null;

  @override
  LanNetworkState build() {
    ref.onDispose(() {
      _syncTimer?.cancel();
    });

    final prefs = _prefs;
    final initialConfig = prefs != null
        ? NetworkConfig.loadFromPrefs(prefs)
        : const NetworkConfig();

    _initNetwork(initialConfig);

    return LanNetworkState(config: initialConfig);
  }

  Future<void> _initNetwork(NetworkConfig cfg) async {
    final ips = await NetworkUtils.getLocalIpv4Addresses();

    if (cfg.mode == NetworkMode.server && _server != null) {
      final success = await _server!.start(
        port: cfg.serverPort,
        authToken: cfg.authToken,
      );
      state = state.copyWith(
        serverLocalIps: ips,
        isServerRunning: success,
        statusMessage: success
            ? 'Sunucu aktif (Port: ${cfg.serverPort})'
            : 'Sunucu başlatılamadı!',
      );
    } else if (cfg.mode == NetworkMode.client) {
      state = state.copyWith(serverLocalIps: ips);
      await testConnection();
      _setupSyncTimer(cfg);
    } else {
      state = state.copyWith(serverLocalIps: ips);
    }
  }

  void _setupSyncTimer(NetworkConfig cfg) {
    _syncTimer?.cancel();
    if (cfg.mode == NetworkMode.client && cfg.autoSyncEnabled) {
      final interval = Duration(seconds: cfg.syncIntervalSeconds.clamp(5, 300));
      _syncTimer = Timer.periodic(interval, (_) => syncNow());
    }
  }

  Future<void> updateConfig(NetworkConfig newConfig) async {
    final prefs = _prefs;
    if (prefs != null) {
      await newConfig.saveToPrefs(prefs);
    }

    if (state.config.mode == NetworkMode.server && newConfig.mode != NetworkMode.server) {
      await _server?.stop();
    }

    state = state.copyWith(config: newConfig);
    await _initNetwork(newConfig);
  }

  Future<void> setMode(NetworkMode mode) async {
    final updated = state.config.copyWith(mode: mode);
    await updateConfig(updated);
  }

  Future<bool> startServer() async {
    if (_server == null) return false;
    final cfg = state.config;
    final success = await _server!.start(
      port: cfg.serverPort,
      authToken: cfg.authToken,
    );
    final ips = await NetworkUtils.getLocalIpv4Addresses();
    state = state.copyWith(
      isServerRunning: success,
      serverLocalIps: ips,
      statusMessage: success ? 'Sunucu başarıyla başlatıldı.' : 'Sunucu başlatılamadı.',
    );
    return success;
  }

  Future<void> stopServer() async {
    await _server?.stop();
    state = state.copyWith(
      isServerRunning: false,
      statusMessage: 'Sunucu durduruldu.',
    );
  }

  Future<bool> testConnection({String? host, int? port, String? token}) async {
    if (_client == null) return false;
    final targetHost = host ?? state.config.serverHost;
    final targetPort = port ?? state.config.serverPort;
    final targetToken = token ?? state.config.authToken;

    state = state.copyWith(
      clientStatus: LanConnectionStatus.connecting,
      statusMessage: 'Sunucuya bağlanılıyor ($targetHost:$targetPort)...',
    );

    final result = await _client!.checkHealth(
      host: targetHost,
      port: targetPort,
      token: targetToken,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        clientStatus: LanConnectionStatus.connected,
        pingMs: result.pingMs,
        statusMessage: 'Merkez sunucuya bağlandı (${result.pingMs} ms)',
      );
      return true;
    } else {
      state = state.copyWith(
        clientStatus: LanConnectionStatus.error,
        pingMs: result.pingMs,
        statusMessage: result.errorMessage ?? 'Bağlantı kurulamadı.',
      );
      return false;
    }
  }

  Future<bool> syncNow() async {
    if (state.isSyncing || _syncService == null) return false;
    final cfg = state.config;
    if (cfg.mode != NetworkMode.client) return false;

    state = state.copyWith(isSyncing: true);

    try {
      final success = await _syncService!.pullFromServer(
        host: cfg.serverHost,
        port: cfg.serverPort,
        token: cfg.authToken,
      );

      final now = DateTime.now();
      final updatedConfig = cfg.copyWith(lastSyncTime: now);
      final prefs = _prefs;
      if (prefs != null) {
        await updatedConfig.saveToPrefs(prefs);
      }

      state = state.copyWith(
        isSyncing: false,
        config: updatedConfig,
        clientStatus: success ? LanConnectionStatus.connected : LanConnectionStatus.error,
        statusMessage: success
            ? 'Senkronizasyon başarılı (${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')})'
            : 'Senkronizasyon sırasında hata oluştu.',
      );
      return success;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        clientStatus: LanConnectionStatus.error,
        statusMessage: 'Senkronizasyon hatası: $e',
      );
      return false;
    }
  }
}

final lanNetworkProvider = NotifierProvider<LanNetworkNotifier, LanNetworkState>(
  () => LanNetworkNotifier(),
);
