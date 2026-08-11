import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/personnel_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PersonnelTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
