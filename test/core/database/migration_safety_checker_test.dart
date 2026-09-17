import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/migration_safety_checker.dart';

class TestDatabase extends GeneratedDatabase {
  TestDatabase(super.executor);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  int get schemaVersion => 7;
}

void main() {
  group('MigrationSafetyChecker Tests', () {
    late TestDatabase db;
    late MigrationSafetyChecker checker;

    setUp(() async {
      db = TestDatabase(NativeDatabase.memory());
      checker = MigrationSafetyChecker(db);

      // Create v7 tables in memory
      await db.customStatement('''
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

      await db.customStatement('''
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

      await db.customStatement('''
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

      await db.customStatement('''
        CREATE TABLE task_personnel_table (
          task_id TEXT NOT NULL,
          personnel_id TEXT NOT NULL,
          PRIMARY KEY (task_id, personnel_id)
        );
      ''');

      await db.customStatement('''
        CREATE TABLE personnel_history_table (
          id TEXT NOT NULL PRIMARY KEY,
          personnel_id TEXT NOT NULL,
          action TEXT NOT NULL DEFAULT '',
          description TEXT NOT NULL DEFAULT '',
          created_at INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await db.customStatement('''
        CREATE TABLE settings_table (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          app_name TEXT NOT NULL DEFAULT 'PGYS',
          date_format TEXT NOT NULL DEFAULT 'dd.MM.yyyy',
          theme_mode TEXT NOT NULL DEFAULT 'system',
          updated_at INTEGER NOT NULL DEFAULT 0
        );
      ''');
    });

    tearDown(() async {
      await db.close();
    });

    test('Clean database reports isSafeForMigration == true', () async {
      // Add valid personnel and matched child records
      await db.customStatement(
        "INSERT INTO personnel_table (id, registry_number) VALUES (1, '100001');",
      );
      await db.customStatement(
        "INSERT INTO leave_table (id, personnel_id) VALUES ('l-1', '100001');",
      );
      await db.customStatement(
        "INSERT INTO task_table (id) VALUES ('t-1');",
      );
      await db.customStatement(
        "INSERT INTO task_personnel_table (task_id, personnel_id) VALUES ('t-1', '100001');",
      );
      await db.customStatement(
        "INSERT INTO personnel_history_table (id, personnel_id) VALUES ('h-1', '100001');",
      );
      await db.customStatement(
        "INSERT INTO settings_table (id) VALUES (1);",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isTrue);
      expect(report.hasDuplicates, isFalse);
      expect(report.hasEmptyOrNullRegistries, isFalse);
      expect(report.hasOrphans, isFalse);
      expect(report.personnelRowCount, equals(1));
      expect(report.leaveRowCount, equals(1));
      expect(report.taskRowCount, equals(1));
      expect(report.taskPersonnelRowCount, equals(1));
      expect(report.historyRowCount, equals(1));
      expect(report.settingsRowCount, equals(1));
    });

    test('Detects duplicate registry_number and lists conflicting IDs', () async {
      await db.customStatement(
        "INSERT INTO personnel_table (id, registry_number) VALUES (1, '100001');",
      );
      await db.customStatement(
        "INSERT INTO personnel_table (id, registry_number) VALUES (2, '100001');",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isFalse);
      expect(report.hasDuplicates, isTrue);
      expect(report.duplicateRegistries.length, equals(1));
      expect(report.duplicateRegistries.first.registryNumber, equals('100001'));
      expect(report.duplicateRegistries.first.count, equals(2));
      expect(report.duplicateRegistries.first.personnelIds, containsAll([1, 2]));
    });

    test('Detects empty or whitespace-only registry_number', () async {
      await db.customStatement(
        "INSERT INTO personnel_table (id, registry_number) VALUES (1, '   ');",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isFalse);
      expect(report.hasEmptyOrNullRegistries, isTrue);
      expect(report.emptyOrNullRegistryCount, equals(1));
    });

    test('Detects orphaned leave records', () async {
      await db.customStatement(
        "INSERT INTO personnel_table (id, registry_number) VALUES (1, '100001');",
      );
      // Orphan leave with non-existent registry '999999'
      await db.customStatement(
        "INSERT INTO leave_table (id, personnel_id) VALUES ('l-orphan', '999999');",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isFalse);
      expect(report.hasOrphans, isTrue);
      expect(report.orphanedLeaveCount, equals(1));
    });

    test('Detects orphaned task_personnel records', () async {
      await db.customStatement(
        "INSERT INTO task_table (id) VALUES ('t-1');",
      );
      await db.customStatement(
        "INSERT INTO task_personnel_table (task_id, personnel_id) VALUES ('t-1', '999999');",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isFalse);
      expect(report.hasOrphans, isTrue);
      expect(report.orphanedTaskPersonnelCount, equals(1));
    });

    test('Detects orphaned personnel_history records', () async {
      await db.customStatement(
        "INSERT INTO personnel_history_table (id, personnel_id) VALUES ('h-orphan', '999999');",
      );

      final report = await checker.check();

      expect(report.isSafeForMigration, isFalse);
      expect(report.hasOrphans, isTrue);
      expect(report.orphanedHistoryCount, equals(1));
    });
  });
}
