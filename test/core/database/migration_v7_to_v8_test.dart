import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';

class _V7TestDatabase extends GeneratedDatabase {
  _V7TestDatabase(super.executor);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  int get schemaVersion => 7;
}

void main() {
  group('Schema Migration v7 to v8 Integration Test', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('pgys_migration_test_');
      dbFile = File(p.join(tempDir.path, 'test_v7.sqlite'));

      // 1. Create a schema v7 database with raw SQLite
      final rawDb = _V7TestDatabase(NativeDatabase(dbFile));

      await rawDb.customStatement('PRAGMA user_version = 7;');

      await rawDb.customStatement('''
        CREATE TABLE personnel_table (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          registry_number TEXT NOT NULL,
          full_name TEXT NOT NULL DEFAULT '',
          rank TEXT NOT NULL DEFAULT '',
          title TEXT NOT NULL DEFAULT '',
          branch TEXT NOT NULL DEFAULT '',
          department TEXT NOT NULL DEFAULT '',
          start_date INTEGER NOT NULL DEFAULT 0,
          end_date INTEGER NULL,
          phone TEXT NOT NULL DEFAULT '',
          email TEXT NOT NULL DEFAULT '',
          address TEXT NOT NULL DEFAULT '',
          status TEXT NOT NULL DEFAULT 'duty',
          created_at INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await rawDb.customStatement('''
        CREATE TABLE leave_table (
          id TEXT NOT NULL PRIMARY KEY,
          personnel_id TEXT NOT NULL,
          start_date INTEGER NOT NULL DEFAULT 0,
          end_date INTEGER NOT NULL DEFAULT 0,
          type TEXT NOT NULL DEFAULT 'annual',
          description TEXT NOT NULL DEFAULT '',
          address TEXT NOT NULL DEFAULT '',
          created_at INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await rawDb.customStatement('''
        CREATE TABLE task_table (
          id TEXT NOT NULL PRIMARY KEY,
          title TEXT NOT NULL DEFAULT '',
          description TEXT NOT NULL DEFAULT '',
          status TEXT NOT NULL DEFAULT 'inProgress',
          start_date INTEGER NOT NULL DEFAULT 0,
          end_date INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await rawDb.customStatement('''
        CREATE TABLE task_personnel_table (
          task_id TEXT NOT NULL,
          personnel_id TEXT NOT NULL,
          PRIMARY KEY (task_id, personnel_id)
        );
      ''');

      await rawDb.customStatement('''
        CREATE TABLE personnel_history_table (
          id TEXT NOT NULL PRIMARY KEY,
          personnel_id TEXT NOT NULL,
          action TEXT NOT NULL DEFAULT '',
          description TEXT NOT NULL DEFAULT '',
          created_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await rawDb.customStatement('''
        CREATE TABLE settings_table (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          app_name TEXT NOT NULL DEFAULT 'PGYS',
          date_format TEXT NOT NULL DEFAULT 'dd.MM.yyyy',
          theme_mode TEXT NOT NULL DEFAULT 'system',
          updated_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      // Seed v7 data with string registry_number in child tables
      await rawDb.customStatement(
        "INSERT INTO personnel_table (id, registry_number, full_name) VALUES (10, 'REG-001', 'Ahmet Yilmaz');",
      );
      await rawDb.customStatement(
        "INSERT INTO personnel_table (id, registry_number, full_name) VALUES (20, 'REG-002', 'Mehmet Demir');",
      );

      await rawDb.customStatement(
        "INSERT INTO leave_table (id, personnel_id, description) VALUES ('leave-1', 'REG-001', 'Yillik Izin');",
      );

      await rawDb.customStatement(
        "INSERT INTO task_table (id, title) VALUES ('task-1', 'Sistem Bakimi');",
      );
      await rawDb.customStatement(
        "INSERT INTO task_personnel_table (task_id, personnel_id) VALUES ('task-1', 'REG-001');",
      );
      await rawDb.customStatement(
        "INSERT INTO task_personnel_table (task_id, personnel_id) VALUES ('task-1', 'REG-002');",
      );

      await rawDb.customStatement(
        "INSERT INTO personnel_history_table (id, personnel_id, action, description) VALUES ('hist-1', 'REG-002', 'create', 'Kayit olusturuldu');",
      );

      await rawDb.close();
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Drift AppDatabase migration converts child personnel_id to integer PK and enforces cascade delete', () async {
      // 2. Open with AppDatabase (schemaVersion 8) which triggers onUpgrade
      final db = AppDatabase(NativeDatabase(dbFile));

      // Query leaves
      final leaves = await db.select(db.leaveTable).get();
      expect(leaves.length, equals(1));
      expect(leaves.first.personnelId, equals(10)); // Mapped from 'REG-001' to 10!
      expect(leaves.first.description, equals('Yillik Izin'));

      // Query task personnel
      final taskPersonnel = await db.select(db.taskPersonnelTable).get();
      expect(taskPersonnel.length, equals(2));
      expect(taskPersonnel.map((tp) => tp.personnelId), containsAll([10, 20]));

      // Query history
      final histories = await db.select(db.personnelHistoryTable).get();
      expect(histories.length, equals(1));
      expect(histories.first.personnelId, equals(20));

      // Test cascade delete: deleting personnel 10 should cascade delete leave-1 and task-personnel assignment
      await (db.delete(db.personnelTable)..where((tbl) => tbl.id.equals(10))).go();

      final remainingLeaves = await db.select(db.leaveTable).get();
      expect(remainingLeaves, isEmpty); // Cascaded!

      final remainingTaskPersonnel = await db.select(db.taskPersonnelTable).get();
      expect(remainingTaskPersonnel.length, equals(1));
      expect(remainingTaskPersonnel.first.personnelId, equals(20)); // Only Mehmet remains

      await db.close();
    });
  });
}
