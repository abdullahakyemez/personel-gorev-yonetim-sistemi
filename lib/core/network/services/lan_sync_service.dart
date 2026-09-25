import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';
import 'lan_client.dart';
import 'lan_server.dart';

class LanSyncService {
  final AppDatabase database;
  final LanServer server;
  final LanClient client;

  LanSyncService({
    required this.database,
    required this.server,
    required this.client,
  });

  /// Gathers all records from local SQLite database into a sync payload.
  Future<LanSyncPayload> createLocalSyncPayload() async {
    final users = await _getTableData('user_table');
    final personnel = await _getTableData('personnel_table');
    final tasks = await _getTableData('task_table');
    final taskPersonnel = await _getTableData('task_personnel_table');
    final leave = await _getTableData('leave_table');
    final personnelHistory = await _getTableData('personnel_history_table');
    final settings = await _getTableData('settings_table');

    return LanSyncPayload(
      timestamp: DateTime.now(),
      schemaVersion: database.schemaVersion,
      users: users,
      personnel: personnel,
      tasks: tasks,
      taskPersonnel: taskPersonnel,
      leave: leave,
      personnelHistory: personnelHistory,
      settings: settings,
    );
  }

  /// Atomically writes incoming payload records into local database.
  Future<void> applySyncPayloadToLocalDb(LanSyncPayload payload) async {
    await database.transaction(() async {
      await database.customStatement('PRAGMA foreign_keys = OFF;');

      if (payload.settings.isNotEmpty) {
        await _applyTableData('settings_table', payload.settings);
      }
      if (payload.personnel.isNotEmpty) {
        await _applyTableData('personnel_table', payload.personnel);
      }
      if (payload.users.isNotEmpty) {
        await _applyTableData('user_table', payload.users);
      }
      if (payload.tasks.isNotEmpty) {
        await _applyTableData('task_table', payload.tasks);
      }
      if (payload.taskPersonnel.isNotEmpty) {
        await _applyTableData('task_personnel_table', payload.taskPersonnel);
      }
      if (payload.leave.isNotEmpty) {
        await _applyTableData('leave_table', payload.leave);
      }
      if (payload.personnelHistory.isNotEmpty) {
        await _applyTableData('personnel_history_table', payload.personnelHistory);
      }

      await database.customStatement('PRAGMA foreign_keys = ON;');
    });
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
  }) async {
    try {
      final localPayload = await createLocalSyncPayload();
      return await client.pushSyncData(
        host: host,
        port: port,
        token: token,
        payload: localPayload,
      );
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> _getTableData(String tableName) async {
    try {
      final rows = await database.customSelect('SELECT * FROM $tableName;').get();
      return rows.map((r) => Map<String, dynamic>.from(r.data)).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _applyTableData(String tableName, List<Map<String, dynamic>> rows) async {
    for (final row in rows) {
      if (row.isEmpty) continue;
      final keys = row.keys.toList();
      final columns = keys.map((k) => '"$k"').join(', ');
      final placeholders = List.filled(keys.length, '?').join(', ');
      final values = keys.map((k) => row[k]).toList();

      await database.customStatement(
        'INSERT OR REPLACE INTO $tableName ($columns) VALUES ($placeholders);',
        values,
      );
    }
  }
}
