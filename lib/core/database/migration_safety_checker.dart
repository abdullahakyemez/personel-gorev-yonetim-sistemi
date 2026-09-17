import 'package:drift/drift.dart';

class DuplicateRegistryRecord {
  final String registryNumber;
  final int count;
  final List<int> personnelIds;

  const DuplicateRegistryRecord({
    required this.registryNumber,
    required this.count,
    required this.personnelIds,
  });
}

class MigrationSafetyReport {
  final int personnelRowCount;
  final int leaveRowCount;
  final int taskRowCount;
  final int taskPersonnelRowCount;
  final int historyRowCount;
  final int settingsRowCount;

  final List<DuplicateRegistryRecord> duplicateRegistries;
  final int emptyOrNullRegistryCount;

  final int orphanedLeaveCount;
  final int orphanedTaskPersonnelCount;
  final int orphanedHistoryCount;

  const MigrationSafetyReport({
    required this.personnelRowCount,
    required this.leaveRowCount,
    required this.taskRowCount,
    required this.taskPersonnelRowCount,
    required this.historyRowCount,
    required this.settingsRowCount,
    required this.duplicateRegistries,
    required this.emptyOrNullRegistryCount,
    required this.orphanedLeaveCount,
    required this.orphanedTaskPersonnelCount,
    required this.orphanedHistoryCount,
  });

  bool get hasDuplicates => duplicateRegistries.isNotEmpty;
  bool get hasEmptyOrNullRegistries => emptyOrNullRegistryCount > 0;
  bool get hasOrphans =>
      orphanedLeaveCount > 0 ||
      orphanedTaskPersonnelCount > 0 ||
      orphanedHistoryCount > 0;

  bool get isSafeForMigration =>
      !hasDuplicates && !hasEmptyOrNullRegistries && !hasOrphans;
}

class MigrationSafetyChecker {
  final GeneratedDatabase database;

  const MigrationSafetyChecker(this.database);

  Future<MigrationSafetyReport> check() async {
    final personnelCount = await _countTable('personnel_table');
    final leaveCount = await _countTable('leave_table');
    final taskCount = await _countTable('task_table');
    final taskPersonnelCount = await _countTable('task_personnel_table');
    final historyCount = await _countTable('personnel_history_table');
    final settingsCount = await _countTable('settings_table');

    final duplicateRows = await database.customSelect('''
      SELECT registry_number, COUNT(*) AS cnt, GROUP_CONCAT(id) AS ids
      FROM personnel_table
      GROUP BY registry_number
      HAVING COUNT(*) > 1;
    ''').get();

    final duplicates = duplicateRows.map((row) {
      final regNo = row.read<String>('registry_number');
      final cnt = row.read<int>('cnt');
      final idsStr = row.read<String?>('ids') ?? '';
      final ids = idsStr
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
      return DuplicateRegistryRecord(
        registryNumber: regNo,
        count: cnt,
        personnelIds: ids,
      );
    }).toList();

    final emptyRows = await database.customSelect('''
      SELECT COUNT(*) AS cnt
      FROM personnel_table
      WHERE registry_number IS NULL OR TRIM(registry_number) = '';
    ''').get();
    final emptyCount = emptyRows.first.read<int>('cnt');

    final orphanLeaveRows = await database.customSelect('''
      SELECT COUNT(*) AS cnt
      FROM leave_table
      WHERE personnel_id NOT IN (SELECT registry_number FROM personnel_table);
    ''').get();
    final orphanLeaveCount = orphanLeaveRows.first.read<int>('cnt');

    final orphanTaskPersonnelRows = await database.customSelect('''
      SELECT COUNT(*) AS cnt
      FROM task_personnel_table
      WHERE personnel_id NOT IN (SELECT registry_number FROM personnel_table);
    ''').get();
    final orphanTaskPersonnelCount = orphanTaskPersonnelRows.first.read<int>('cnt');

    final orphanHistoryRows = await database.customSelect('''
      SELECT COUNT(*) AS cnt
      FROM personnel_history_table
      WHERE personnel_id NOT IN (SELECT registry_number FROM personnel_table);
    ''').get();
    final orphanHistoryCount = orphanHistoryRows.first.read<int>('cnt');

    return MigrationSafetyReport(
      personnelRowCount: personnelCount,
      leaveRowCount: leaveCount,
      taskRowCount: taskCount,
      taskPersonnelRowCount: taskPersonnelCount,
      historyRowCount: historyCount,
      settingsRowCount: settingsCount,
      duplicateRegistries: duplicates,
      emptyOrNullRegistryCount: emptyCount,
      orphanedLeaveCount: orphanLeaveCount,
      orphanedTaskPersonnelCount: orphanTaskPersonnelCount,
      orphanedHistoryCount: orphanHistoryCount,
    );
  }

  Future<int> _countTable(String tableName) async {
    final rows = await database.customSelect(
      'SELECT COUNT(*) AS cnt FROM $tableName;',
    ).get();
    return rows.first.read<int>('cnt');
  }
}
