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
import 'tables/user_table.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PersonnelTable,
    SettingsTable,
    TaskTable,
    TaskPersonnelTable,
    LeaveTable,
    PersonnelHistoryTable,
    UserTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static Future<File> databaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'pgys.sqlite'));
  }

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_personnel_registry_number ON personnel_table(registry_number);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_leave_personnel_id ON leave_table(personnel_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_task_personnel_personnel_id ON task_personnel_table(personnel_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_personnel_history_personnel_id ON personnel_history_table(personnel_id);',
      );
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_user_username ON user_table(username);',
      );
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
      if (from < 8) {
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_personnel_registry_number ON personnel_table(registry_number);',
        );

        await customStatement('''
          CREATE TABLE leave_table_new (
            id TEXT NOT NULL PRIMARY KEY,
            personnel_id INTEGER NOT NULL REFERENCES personnel_table (id) ON DELETE CASCADE,
            start_date INTEGER NOT NULL,
            end_date INTEGER NOT NULL,
            type TEXT NOT NULL,
            description TEXT NOT NULL,
            address TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
            updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
          );
        ''');
        await customStatement('''
          INSERT INTO leave_table_new (id, personnel_id, start_date, end_date, type, description, address, created_at, updated_at)
          SELECT l.id, p.id, l.start_date, l.end_date, l.type, l.description, l.address, l.created_at, l.updated_at
          FROM leave_table l
          JOIN personnel_table p ON p.registry_number = l.personnel_id;
        ''');
        await customStatement('DROP TABLE leave_table;');
        await customStatement('ALTER TABLE leave_table_new RENAME TO leave_table;');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_leave_personnel_id ON leave_table(personnel_id);',
        );

        await customStatement('''
          CREATE TABLE task_personnel_table_new (
            task_id TEXT NOT NULL REFERENCES task_table (id) ON DELETE CASCADE,
            personnel_id INTEGER NOT NULL REFERENCES personnel_table (id) ON DELETE CASCADE,
            PRIMARY KEY (task_id, personnel_id)
          );
        ''');
        await customStatement('''
          INSERT INTO task_personnel_table_new (task_id, personnel_id)
          SELECT tp.task_id, p.id
          FROM task_personnel_table tp
          JOIN personnel_table p ON p.registry_number = tp.personnel_id;
        ''');
        await customStatement('DROP TABLE task_personnel_table;');
        await customStatement('ALTER TABLE task_personnel_table_new RENAME TO task_personnel_table;');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_task_personnel_personnel_id ON task_personnel_table(personnel_id);',
        );

        await customStatement('''
          CREATE TABLE personnel_history_table_new (
            id TEXT NOT NULL PRIMARY KEY,
            personnel_id INTEGER NOT NULL REFERENCES personnel_table (id) ON DELETE CASCADE,
            action TEXT NOT NULL,
            description TEXT NOT NULL,
            created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
          );
        ''');
        await customStatement('''
          INSERT INTO personnel_history_table_new (id, personnel_id, action, description, created_at)
          SELECT h.id, p.id, h.action, h.description, h.created_at
          FROM personnel_history_table h
          JOIN personnel_table p ON p.registry_number = h.personnel_id;
        ''');
        await customStatement('DROP TABLE personnel_history_table;');
        await customStatement('ALTER TABLE personnel_history_table_new RENAME TO personnel_history_table;');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_personnel_history_personnel_id ON personnel_history_table(personnel_id);',
        );
      }
      if (from < 9) {
        await m.createTable(userTable);
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS idx_user_username ON user_table(username);',
        );
      } else if (from < 10) {
        await m.addColumn(userTable, userTable.requiresPasswordChange);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
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
