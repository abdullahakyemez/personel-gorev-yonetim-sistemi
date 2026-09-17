import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/database_backup_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseBackupService Tests', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase db;
    late DatabaseBackupService service;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('pgys_backup_test_');
      dbFile = File(p.join(tempDir.path, 'pgys_test.sqlite'));
      db = AppDatabase(NativeDatabase(dbFile));
      service = DatabaseBackupService(db);

      // Populate dummy data
      await db.into(db.personnelTable).insert(
            PersonnelTableCompanion.insert(
              registryNumber: 'SICIL001',
              fullName: 'Ahmet Yılmaz',
              rank: 'Mühendis',
              title: 'Geliştirici',
              branch: 'Yazılım',
              department: 'IT',
              startDate: DateTime.now(),
              phone: '05551112233',
              email: 'ahmet@example.com',
              address: 'Ankara',
              status: const Value('duty'),
            ),
          );

      await db.into(db.taskTable).insert(
            TaskTableCompanion.insert(
              id: 'TASK001',
              title: 'Sistem Güncellemesi',
              description: 'Açıklama',
              status: 'pending',
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 1)),
            ),
          );

      await db.into(db.leaveTable).insert(
            LeaveTableCompanion.insert(
              id: 'LEAVE001',
              personnelId: 1,
              type: 'annual',
              description: 'Yıllık izin',
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 5)),
            ),
          );
    });

    tearDown(() async {
      await db.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('validateBackupFile returns invalid for non-existent file', () async {
      final nonExistent = p.join(tempDir.path, 'does_not_exist.sqlite');
      final result = await service.validateBackupFile(nonExistent);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('bulunamadı'));
    });

    test('validateBackupFile returns invalid for small or empty file', () async {
      final emptyFile = File(p.join(tempDir.path, 'empty.sqlite'));
      await emptyFile.writeAsString('too short');

      final result = await service.validateBackupFile(emptyFile.path);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Dosya boyutu geçersiz'));
    });

    test('validateBackupFile returns invalid for non-sqlite corrupt file', () async {
      final fakeFile = File(p.join(tempDir.path, 'fake.sqlite'));
      final garbage = List<int>.filled(1024, 65); // 1KB of 'A'
      await fakeFile.writeAsBytes(garbage);

      final result = await service.validateBackupFile(fakeFile.path);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('SQLite'));
    });

    test('validateBackupFile returns invalid for SQLite without PGYS tables', () async {
      final rawFile = File(p.join(tempDir.path, 'other.sqlite'));
      final rawDb = sq.sqlite3.open(rawFile.path);
      rawDb.execute('CREATE TABLE random_table (id INTEGER PRIMARY KEY);');
      rawDb.dispose();

      final result = await service.validateBackupFile(rawFile.path);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('personnel_table'));
    });

    test('exportBackup with customTargetPath creates valid backup file', () async {
      final exportPath = p.join(tempDir.path, 'exported_backup.sqlite');
      final savedPath = await service.exportBackup(customTargetPath: exportPath);

      expect(savedPath, isNotNull);
      final exportedFile = File(savedPath!);
      expect(await exportedFile.exists(), isTrue);

      // Validate the exported backup using service
      final validation = await service.validateBackupFile(savedPath);
      expect(validation.isValid, isTrue);
      expect(validation.personnelCount, equals(1));
      expect(validation.taskCount, equals(1));
      expect(validation.leaveCount, equals(1));
    });

    test('restoreBackup throws StateError when source file is invalid', () async {
      final invalidFile = File(p.join(tempDir.path, 'invalid.sqlite'));
      await invalidFile.writeAsString('not a sqlite database');

      expect(
        () => service.restoreBackup(invalidFile.path),
        throwsA(isA<StateError>()),
      );
    });

    test('createSafetySnapshot creates backup file when database exists', () async {
      final snapshot = await service.createSafetySnapshot(sourceDbFile: dbFile);
      expect(snapshot, isNotNull);
      expect(await snapshot!.exists(), isTrue);
      expect(p.basename(snapshot.path), equals('pgys_pre_restore_safety_backup.sqlite'));
    });

    test('restoreBackup restores valid backup onto target database', () async {
      final exportPath = p.join(tempDir.path, 'valid_backup.sqlite');
      await service.exportBackup(customTargetPath: exportPath);

      final restoredDbFile = File(p.join(tempDir.path, 'restored_target.sqlite'));
      await restoredDbFile.writeAsString('initial dummy');

      await service.restoreBackup(
        exportPath,
        targetDbFile: restoredDbFile,
        skipSnapshot: true,
      );

      expect(await restoredDbFile.exists(), isTrue);
      final validation = await service.validateBackupFile(restoredDbFile.path);
      expect(validation.isValid, isTrue);
      expect(validation.personnelCount, equals(1));
    });

    test('rollbackSafetySnapshot successfully restores pre-restore state', () async {
      final targetDb = File(p.join(tempDir.path, 'rollback_target.sqlite'));
      await dbFile.copy(targetDb.path);

      // Create safety snapshot
      final snapshot = await service.createSafetySnapshot(sourceDbFile: targetDb);
      expect(snapshot, isNotNull);

      // Corrupt targetDb
      await targetDb.writeAsString('corrupted data');

      // Execute rollback
      final success = await service.rollbackSafetySnapshot(targetDbFile: targetDb);
      expect(success, isTrue);

      // Verify targetDb is healthy again
      final validation = await service.validateBackupFile(targetDb.path);
      expect(validation.isValid, isTrue);
      expect(validation.personnelCount, equals(1));
    });

    test('rollbackSafetySnapshot throws StateError when no snapshot exists', () async {
      final fakeDb = File(p.join(tempDir.path, 'no_snap_dir', 'fake.sqlite'));
      await fakeDb.parent.create(recursive: true);
      await fakeDb.writeAsString('dummy');

      expect(
        () => service.rollbackSafetySnapshot(targetDbFile: fakeDb),
        throwsA(isA<StateError>()),
      );
    });

    test('performAutoBackupIfNeeded creates backup and prunes old backups according to retention limit', () async {
      final backupDir = Directory(p.join(tempDir.path, 'auto_backups'));
      await backupDir.create(recursive: true);

      // Create 3 dummy older backup files
      for (int i = 1; i <= 3; i++) {
        final f = File(p.join(backupDir.path, 'pgys-otomatik-yedek-2026010$i-100000.sqlite'));
        await dbFile.copy(f.path);
        // Ensure different timestamps
        f.setLastModifiedSync(DateTime(2026, 1, i, 10, 0));
      }

      const settings = AppSettings(
        appName: 'Test',
        dateFormat: 'dd.MM.yyyy',
        themeMode: AppThemeMode.system,
        autoBackupEnabled: true,
        autoBackupIntervalHours: 24,
        maxBackupRetentionCount: 2, // Only keep 2!
      );

      final result = await service.performAutoBackupIfNeeded(
        settings: settings,
        customDirectory: backupDir.path,
        now: DateTime(2026, 1, 10, 12, 0),
      );

      expect(result.success, isTrue);
      expect(result.backupPath, isNotNull);
      // We had 3 files + 1 new file = 4 files, retention is 2 -> pruned 2 files!
      expect(result.prunedCount, equals(2));

      final remaining = await service.listAvailableBackups(directory: backupDir);
      expect(remaining.length, equals(2));
    });

    test('listAvailableBackups returns empty when directory is empty', () async {
      final emptyDir = Directory(p.join(tempDir.path, 'empty_backups'));
      await emptyDir.create();

      final list = await service.listAvailableBackups(directory: emptyDir);
      expect(list, isEmpty);
    });
  });
}
