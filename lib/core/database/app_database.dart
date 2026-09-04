import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/personnel_table.dart';
import 'tables/settings_table.dart';
import 'tables/task_personnel_table.dart';
import 'tables/task_table.dart';
import 'tables/leave_table.dart';
import 'tables/personnel_history_table.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PersonnelTable,
    SettingsTable,
    TaskTable,
    TaskPersonnelTable,
    LeaveTable,
    PersonnelHistoryTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(personnelTable, personnelTable.workScheduleType);

        await m.addColumn(personnelTable, personnelTable.workScheduleDutyDays);

        await m.addColumn(personnelTable, personnelTable.workScheduleRestDays);

        await m.addColumn(personnelTable, personnelTable.workScheduleStartDate);
      }
      if (from < 3) {
        await m.createTable(settingsTable);
      }
      if (from < 4) {
        await m.createTable(taskTable);
        await m.createTable(taskPersonnelTable);
      }
      if (from < 5) {
        await m.createTable(leaveTable);
      }
      if (from < 6) {
        await m.createTable(personnelHistoryTable);
      }
      if (from < 7) {
        await m.addColumn(leaveTable, leaveTable.address);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pgys.sqlite'));
    return NativeDatabase(file);
  });
}
