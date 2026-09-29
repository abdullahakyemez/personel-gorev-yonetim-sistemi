import 'dart:async';
import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';

class LanSyncApplier {
  final AppDatabase database;

  LanSyncApplier(this.database);

  Future<LanSyncPayload> createSyncPayload({bool includeUsers = true}) async {
    final users = includeUsers ? await getTableData('user_table') : <Map<String, dynamic>>[];
    final personnel = await getTableData('personnel_table');
    final tasks = await getTableData('task_table');
    final taskPersonnel = await getTableData('task_personnel_table');
    final leave = await getTableData('leave_table');
    final personnelHistory = await getTableData('personnel_history_table');
    final settings = await getTableData('settings_table');
    final deletions = await getTableData('sync_deletions_table');

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
      deletions: deletions,
    );
  }

  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    try {
      final rows = await database.customSelect('SELECT * FROM $tableName;').get();
      return rows.map((r) => Map<String, dynamic>.from(r.data)).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> applyPayload(LanSyncPayload payload) async {
    await database.transaction(() async {
      await database.customStatement('PRAGMA foreign_keys = OFF;');

      // 1. Silme kayıtlarını (tombstones) yerel veritabanına uygula
      if (payload.deletions.isNotEmpty) {
        await applyDeletions(payload.deletions);
      }

      // 2. Ayarları senkronize et
      if (payload.settings.isNotEmpty) {
        await applyRawTableData('settings_table', payload.settings);
      }

      // 3. Personelleri sicil numarası bazında çakışmasız uygula ve ID eşleme tablosunu oluştur
      final idMapping = <int, int>{};
      if (payload.personnel.isNotEmpty) {
        await applyPersonnelData(payload.personnel, idMapping);
      }

      // 4. Kullanıcı tablosu
      if (payload.users.isNotEmpty) {
        await applyUserData(payload.users, idMapping);
      }

      // 5. Görevler (Silinmiş görevlerin hortlamasını engelleyerek)
      if (payload.tasks.isNotEmpty) {
        await applyTableDataWithDeletionCheck('task_table', payload.tasks);
      }

      // 6. Görev-Personel ilişkileri
      if (payload.taskPersonnel.isNotEmpty) {
        await applyTaskPersonnelData(payload.taskPersonnel, idMapping);
      }

      // 7. İzinler
      if (payload.leave.isNotEmpty) {
        await applyTableDataWithDeletionCheck(
          'leave_table',
          payload.leave,
          idMapping: idMapping,
          personnelIdKey: 'personnel_id',
        );
      }

      // 8. Personel geçmişi
      if (payload.personnelHistory.isNotEmpty) {
        await applyTableDataWithDeletionCheck(
          'personnel_history_table',
          payload.personnelHistory,
          idMapping: idMapping,
          personnelIdKey: 'personnel_id',
        );
      }

      await database.customStatement('PRAGMA foreign_keys = ON;');
    });
  }

  Future<void> applyDeletions(List<Map<String, dynamic>> deletions) async {
    for (final del in deletions) {
      final tableName = del['table_name'] as String?;
      final recordId = del['record_id']?.toString();
      if (tableName == null || recordId == null) continue;

      if (tableName == 'personnel_table') {
        final id = int.tryParse(recordId);
        if (id != null) {
          await database.customStatement('DELETE FROM personnel_table WHERE id = ?;', [id]);
        }
      } else {
        await database.customStatement('DELETE FROM $tableName WHERE id = ?;', [recordId]);
      }

      // Silme kaydını yerel sync_deletions_table tablosuna da kaydet
      final idVal = del['id']?.toString() ?? '${tableName}_$recordId';
      final delAt = del['deleted_at'] ?? DateTime.now().millisecondsSinceEpoch;
      await database.customStatement(
        'INSERT OR REPLACE INTO sync_deletions_table (id, table_name, record_id, deleted_at) VALUES (?, ?, ?, ?);',
        [idVal, tableName, recordId, delAt],
      );
    }
  }

  Future<void> applyPersonnelData(
    List<Map<String, dynamic>> rows,
    Map<int, int> idMapping,
  ) async {
    for (final rawRow in rows) {
      if (rawRow.isEmpty) continue;
      final row = Map<String, dynamic>.from(rawRow);
      final remoteId = row['id'] as int?;
      final regNo = row['registry_number']?.toString();
      if (regNo == null) continue;

      // Yerelde silinmişse tekrar diriltme
      final isDeleted = await _isRecordDeleted('personnel_table', remoteId?.toString() ?? '');
      if (isDeleted) continue;

      // Aynı sicil numarasına sahip yerel personel var mı kontrol et
      final existing = await database.customSelect(
        'SELECT id FROM personnel_table WHERE registry_number = ?;',
        variables: [Variable.withString(regNo)],
      ).getSingleOrNull();

      if (existing != null) {
        final localId = existing.data['id'] as int;
        if (remoteId != null && remoteId != localId) {
          idMapping[remoteId] = localId;
        }

        // id hariç diğer tüm sütunları güncelle
        final updateRow = Map<String, dynamic>.from(row)..remove('id');
        final keys = updateRow.keys.toList();
        final setClause = keys.map((k) => '"$k" = ?').join(', ');
        final values = keys.map((k) => updateRow[k]).toList()..add(localId);

        await database.customStatement(
          'UPDATE personnel_table SET $setClause WHERE id = ?;',
          values,
        );
      } else {
        // Yeni personel. remoteId çakışıyor mu kontrol et
        var targetId = remoteId;
        if (remoteId != null) {
          final idTaken = await database.customSelect(
            'SELECT 1 FROM personnel_table WHERE id = ?;',
            variables: [Variable.withInt(remoteId)],
          ).get();
          if (idTaken.isNotEmpty) {
            targetId = null; // SQLite kendi sıradaki ID'sini atasın
          }
        }

        final insertRow = Map<String, dynamic>.from(row);
        if (targetId == null) {
          insertRow.remove('id');
        } else {
          insertRow['id'] = targetId;
        }

        final keys = insertRow.keys.toList();
        final columns = keys.map((k) => '"$k"').join(', ');
        final placeholders = List.filled(keys.length, '?').join(', ');
        final values = keys.map((k) => insertRow[k]).toList();

        await database.customStatement(
          'INSERT INTO personnel_table ($columns) VALUES ($placeholders);',
          values,
        );

        if (targetId == null && remoteId != null) {
          final created = await database.customSelect(
            'SELECT id FROM personnel_table WHERE registry_number = ?;',
            variables: [Variable.withString(regNo)],
          ).getSingleOrNull();
          if (created != null) {
            idMapping[remoteId] = created.data['id'] as int;
          }
        }
      }
    }
  }

  Future<void> applyUserData(
    List<Map<String, dynamic>> rows,
    Map<int, int> idMapping,
  ) async {
    for (final rawRow in rows) {
      if (rawRow.isEmpty) continue;
      final row = Map<String, dynamic>.from(rawRow);
      final pId = row['personnel_id'] as int?;
      if (pId != null && idMapping.containsKey(pId)) {
        row['personnel_id'] = idMapping[pId];
      }

      final keys = row.keys.toList();
      final columns = keys.map((k) => '"$k"').join(', ');
      final placeholders = List.filled(keys.length, '?').join(', ');
      final values = keys.map((k) => row[k]).toList();

      await database.customStatement(
        'INSERT OR REPLACE INTO user_table ($columns) VALUES ($placeholders);',
        values,
      );
    }
  }

  Future<void> applyTaskPersonnelData(
    List<Map<String, dynamic>> rows,
    Map<int, int> idMapping,
  ) async {
    for (final rawRow in rows) {
      if (rawRow.isEmpty) continue;
      final row = Map<String, dynamic>.from(rawRow);
      final taskId = row['task_id']?.toString();
      var pId = row['personnel_id'] as int?;

      if (taskId != null && await _isRecordDeleted('task_table', taskId)) {
        continue;
      }
      if (pId != null && idMapping.containsKey(pId)) {
        pId = idMapping[pId];
        row['personnel_id'] = pId;
      }
      if (pId != null && await _isRecordDeleted('personnel_table', pId.toString())) {
        continue;
      }

      final keys = row.keys.toList();
      final columns = keys.map((k) => '"$k"').join(', ');
      final placeholders = List.filled(keys.length, '?').join(', ');
      final values = keys.map((k) => row[k]).toList();

      await database.customStatement(
        'INSERT OR REPLACE INTO task_personnel_table ($columns) VALUES ($placeholders);',
        values,
      );
    }
  }

  Future<void> applyTableDataWithDeletionCheck(
    String tableName,
    List<Map<String, dynamic>> rows, {
    Map<int, int>? idMapping,
    String? personnelIdKey,
  }) async {
    for (final rawRow in rows) {
      if (rawRow.isEmpty) continue;
      final row = Map<String, dynamic>.from(rawRow);
      final id = row['id']?.toString();

      // Silinmiş kayıt kontrolü
      if (id != null && await _isRecordDeleted(tableName, id)) {
        continue;
      }

      // personnel_id yeniden eşleme (gerekiyorsa)
      if (idMapping != null && personnelIdKey != null) {
        final pId = row[personnelIdKey] as int?;
        if (pId != null && idMapping.containsKey(pId)) {
          row[personnelIdKey] = idMapping[pId];
        }
      }

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

  Future<void> applyRawTableData(String tableName, List<Map<String, dynamic>> rows) async {
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

  Future<bool> _isRecordDeleted(String tableName, String recordId) async {
    if (recordId.isEmpty) return false;
    try {
      final rows = await database.customSelect(
        'SELECT 1 FROM sync_deletions_table WHERE table_name = ? AND record_id = ?;',
        variables: [Variable.withString(tableName), Variable.withString(recordId)],
      ).get();
      return rows.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
