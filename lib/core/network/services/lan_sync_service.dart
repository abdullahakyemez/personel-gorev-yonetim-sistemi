import 'dart:async';

import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';
import 'lan_client.dart';
import 'lan_server.dart';
import 'lan_sync_applier.dart';

class LanSyncService {
  static final StreamController<String> _localChangeController =
      StreamController<String>.broadcast();

  /// Stream of local database change events.
  static Stream<String> get onLocalChange => _localChangeController.stream;

  /// Notifies the system that local data has been mutated.
  static void notifyDataChanged([String source = 'local']) {
    if (!_localChangeController.isClosed) {
      _localChangeController.add(source);
    }
  }

  final AppDatabase database;

  final LanServer server;
  final LanClient client;
  final LanSyncApplier syncApplier;

  LanSyncService({
    required this.database,
    required this.server,
    required this.client,
    LanSyncApplier? applier,
  }) : syncApplier = applier ?? LanSyncApplier(database);

  /// Gathers all records from local SQLite database into a sync payload.
  Future<LanSyncPayload> createLocalSyncPayload({bool includeUsers = false}) {
    return syncApplier.createSyncPayload(includeUsers: includeUsers);
  }

  /// Atomically writes incoming payload records into local database.
  Future<void> applySyncPayloadToLocalDb(LanSyncPayload payload) {
    return syncApplier.applyPayload(payload);
  }

  /// Performs a full synchronization cycle from client PC with the central LAN server.
  Future<bool> pullFromServer({
    required String host,
    required int port,
    required String token,
  }) async {
    try {
      final remotePayload = await client.fetchSyncData(
        host: host,
        port: port,
        token: token,
      );
      await applySyncPayloadToLocalDb(remotePayload);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Pushes local modifications to the central LAN server.
  Future<bool> pushToServer({
    required String host,
    required int port,
    required String token,
    String? adminToken,
  }) async {
    try {
      final hasAdmin = adminToken != null && adminToken.trim().isNotEmpty;
      final localPayload = await createLocalSyncPayload(includeUsers: hasAdmin);
      return await client.pushSyncData(
        host: host,
        port: port,
        token: token,
        adminToken: adminToken,
        payload: localPayload,
      );
    } catch (_) {
      return false;
    }
  }
}

