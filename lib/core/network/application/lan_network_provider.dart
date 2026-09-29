import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/service_locator.dart';
import '../../../features/leave/application/leave_provider.dart';
import '../../../features/personnel/application/personnel_provider.dart';
import '../../../features/task/application/task_provider.dart';
import '../models/network_config.dart';
import '../services/lan_client.dart';
import '../services/lan_discovery_service.dart';
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
  final bool isWsConnected;

  const LanNetworkState({
    required this.config,
    this.isServerRunning = false,
    this.serverLocalIps = const [],
    this.clientStatus = LanConnectionStatus.idle,
    this.pingMs,
    this.statusMessage,
    this.isSyncing = false,
    this.isWsConnected = false,
  });

  LanNetworkState copyWith({
    NetworkConfig? config,
    bool? isServerRunning,
    List<String>? serverLocalIps,
    LanConnectionStatus? clientStatus,
    int? pingMs,
    String? statusMessage,
    bool? isSyncing,
    bool? isWsConnected,
  }) {
    return LanNetworkState(
      config: config ?? this.config,
      isServerRunning: isServerRunning ?? this.isServerRunning,
      serverLocalIps: serverLocalIps ?? this.serverLocalIps,
      clientStatus: clientStatus ?? this.clientStatus,
      pingMs: pingMs ?? this.pingMs,
      statusMessage: statusMessage ?? this.statusMessage,
      isSyncing: isSyncing ?? this.isSyncing,
      isWsConnected: isWsConnected ?? this.isWsConnected,
    );
  }
}

class LanNetworkNotifier extends Notifier<LanNetworkState> {
  Timer? _syncTimer;
  WebSocket? _webSocket;
  StreamSubscription? _wsSubscription;
  Timer? _wsReconnectTimer;
  StreamSubscription<String>? _localChangeSubscription;
  Timer? _localDebounceTimer;

  LanServer? get _server => getIt.isRegistered<LanServer>() ? getIt<LanServer>() : null;
  LanClient? get _client => getIt.isRegistered<LanClient>() ? getIt<LanClient>() : null;
  LanSyncService? get _syncService => getIt.isRegistered<LanSyncService>() ? getIt<LanSyncService>() : null;
  SharedPreferences? get _prefs => getIt.isRegistered<SharedPreferences>() ? getIt<SharedPreferences>() : null;

  @override
  LanNetworkState build() {
    ref.onDispose(() {
      _cleanupResources();
    });

    _localChangeSubscription = LanSyncService.onLocalChange.listen((source) {
      _handleLocalDataChange(source);
    });

    final prefs = _prefs;
    final initialConfig = prefs != null
        ? NetworkConfig.loadFromPrefs(prefs)
        : const NetworkConfig();

    _initNetwork(initialConfig);

    return LanNetworkState(config: initialConfig);
  }

  void _cleanupResources() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _localDebounceTimer?.cancel();
    _localDebounceTimer = null;
    _localChangeSubscription?.cancel();
    _localChangeSubscription = null;
    _disconnectWebSocket();
  }

  Future<void> _initNetwork(NetworkConfig cfg) async {
    final ips = await NetworkUtils.getLocalIpv4Addresses();

    if (cfg.mode == NetworkMode.server && _server != null) {
      _disconnectWebSocket();
      final success = await _server!.start(
        port: cfg.serverPort,
        authToken: cfg.authToken,
      );
      state = state.copyWith(
        serverLocalIps: ips,
        isServerRunning: success,
        isWsConnected: false,
        statusMessage: success
            ? 'Sunucu aktif (Port: ${cfg.serverPort})'
            : 'Sunucu başlatılamadı!',
      );
    } else if (cfg.mode == NetworkMode.client) {
      state = state.copyWith(serverLocalIps: ips);
      await testConnection();
      _setupSyncTimer(cfg);
      _connectWebSocket(cfg);
    } else {
      _disconnectWebSocket();
      await _server?.stop();
      state = state.copyWith(
        serverLocalIps: ips,
        isServerRunning: false,
        isWsConnected: false,
      );
    }
  }

  void _setupSyncTimer(NetworkConfig cfg) {
    _syncTimer?.cancel();
    if (cfg.mode == NetworkMode.client && cfg.autoSyncEnabled) {
      final interval = Duration(seconds: cfg.syncIntervalSeconds.clamp(5, 300));
      _syncTimer = Timer.periodic(interval, (_) => syncNow());
    }
  }

  void _connectWebSocket(NetworkConfig cfg) {
    if (cfg.mode != NetworkMode.client || _client == null) return;
    _disconnectWebSocket();

    _client!
        .connectWebSocket(
          host: cfg.serverHost,
          port: cfg.serverPort,
          token: cfg.authToken,
        )
        .then((ws) {
          _webSocket = ws;
          state = state.copyWith(isWsConnected: true);
          _wsSubscription = ws.listen(
            (message) {
              _handleWsMessage(message);
            },
            onError: (_) {
              _handleWsDisconnect();
            },
            onDone: () {
              _handleWsDisconnect();
            },
            cancelOnError: true,
          );
        })
        .catchError((_) {
          _scheduleWsReconnect();
        });
  }

  void _handleWsMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString());
      if (data is Map && data['type'] == 'data_changed') {
        syncNow();
      }
    } catch (_) {}
  }

  void _handleWsDisconnect() {
    _disconnectWebSocket();
    state = state.copyWith(isWsConnected: false);
    _scheduleWsReconnect();
  }

  void _scheduleWsReconnect() {
    _wsReconnectTimer?.cancel();
    if (state.config.mode == NetworkMode.client) {
      _wsReconnectTimer = Timer(const Duration(seconds: 5), () {
        if (state.config.mode == NetworkMode.client) {
          _connectWebSocket(state.config);
        }
      });
    }
  }

  void _disconnectWebSocket() {
    _wsReconnectTimer?.cancel();
    _wsReconnectTimer = null;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    try {
      _webSocket?.close();
    } catch (_) {}
    _webSocket = null;
  }

  void _handleLocalDataChange(String source) {
    if (state.config.mode == NetworkMode.server && _server != null) {
      _server!.notifyDataChanged(source: source);
    } else if (state.config.mode == NetworkMode.client) {
      _localDebounceTimer?.cancel();
      _localDebounceTimer = Timer(const Duration(milliseconds: 300), () {
        syncNow();
      });
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
      if (state.config.mode == NetworkMode.client && _webSocket == null) {
        _connectWebSocket(state.config);
      }
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
      // 1. Yereldeki değişiklikleri ve silme kayıtlarını sunucuya gönder (PUSH)
      final pushSuccess = await _syncService!.pushToServer(
        host: cfg.serverHost,
        port: cfg.serverPort,
        token: cfg.authToken,
        adminToken: cfg.adminToken,
      );

      // 2. Sunucudaki en güncel verileri yerel veritabanına çek (PULL)
      final pullSuccess = await _syncService!.pullFromServer(
        host: cfg.serverHost,
        port: cfg.serverPort,
        token: cfg.authToken,
      );

      final success = pushSuccess && pullSuccess;

      final now = DateTime.now();
      final updatedConfig = cfg.copyWith(lastSyncTime: now);
      final prefs = _prefs;
      if (prefs != null) {
        await updatedConfig.saveToPrefs(prefs);
      }

      if (success) {
        // UI'daki tüm verileri ve ekranları anında yenile
        ref.invalidate(personnelListProvider);
        ref.invalidate(taskControllerProvider);
        ref.invalidate(leaveControllerProvider);
      }

      state = state.copyWith(
        isSyncing: false,
        config: updatedConfig,
        clientStatus: success ? LanConnectionStatus.connected : LanConnectionStatus.error,
        statusMessage: success
            ? 'Senkronizasyon başarılı (${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')})'
            : (!pushSuccess ? 'Sunucuya veri aktarılamadı.' : 'Sunucudan veri çekilemedi.'),
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

  /// Yerel ağdaki PGYS Merkez Sunucularını otomatik olarak keşfeder
  Future<List<DiscoveredServer>> scanForServers({
    Duration timeout = const Duration(milliseconds: 1500),
  }) async {
    return LanDiscoveryScanner.scanForServers(timeout: timeout);
  }
}

final lanNetworkProvider = NotifierProvider<LanNetworkNotifier, LanNetworkState>(
  () => LanNetworkNotifier(),
);
