import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sq;

import '../../features/settings/domain/models/app_settings.dart';
import 'app_database.dart';
import 'seed_database.dart';

class BackupFileInfo {
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime modifiedDate;

  const BackupFileInfo({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.modifiedDate,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class AutoBackupResult {
  final bool success;
  final String? backupPath;
  final DateTime? timestamp;
  final int prunedCount;
  final String? message;

  const AutoBackupResult({
    required this.success,
    this.backupPath,
    this.timestamp,
    this.prunedCount = 0,
    this.message,
  });
}

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int? personnelCount;
  final int? userCount;
  final int? taskCount;
  final int? leaveCount;
  final int? fileSizeBytes;
  final DateTime? fileModifiedDate;

  const BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.personnelCount,
    this.userCount,
    this.taskCount,
    this.leaveCount,
    this.fileSizeBytes,
    this.fileModifiedDate,
  });

  const BackupValidationResult.valid({
    this.personnelCount,
    this.userCount,
    this.taskCount,
    this.leaveCount,
    this.fileSizeBytes,
    this.fileModifiedDate,
  })  : isValid = true,
        errorMessage = null;

  const BackupValidationResult.invalid(this.errorMessage)
      : isValid = false,
        personnelCount = null,
        userCount = null,
        taskCount = null,
        leaveCount = null,
        fileSizeBytes = null,
        fileModifiedDate = null;
}

class DatabaseBackupService {
  final AppDatabase database;

  const DatabaseBackupService(this.database);

  static const String safetySnapshotFileName =
      'pgys_pre_restore_safety_backup.sqlite';

  /// Validates whether the given file is a healthy SQLite database containing
  /// the required PGYS tables.
  Future<BackupValidationResult> validateBackupFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return const BackupValidationResult.invalid(
        'Yedek dosyası bulunamadı.',
      );
    }

    final fileSize = await file.length();
    if (fileSize < 512) {
      return const BackupValidationResult.invalid(
        'Dosya boyutu geçersiz veya boş.',
      );
    }

    final stat = await file.stat();
    sq.Database? tempDb;
    try {
      tempDb = sq.sqlite3.open(filePath, mode: sq.OpenMode.readOnly);

      // 1. Veritabanı bütünlük kontrolü
      final integrityResult = tempDb.select('PRAGMA quick_check;');
      if (integrityResult.isNotEmpty) {
        final status = integrityResult.first.values.first?.toString();
        if (status != 'ok') {
          return BackupValidationResult.invalid(
            'Veritabanı dosyası bozuk: $status',
          );
        }
      }

      // 2. Tablo kontrolü
      final tablesResult = tempDb.select(
        "SELECT name FROM sqlite_master WHERE type='table';",
      );
      final tableNames = tablesResult
          .map((row) => (row['name'] as String?)?.toLowerCase())
          .whereType<String>()
          .toSet();

      const requiredTables = [
        'personnel_table',
        'task_table',
        'leave_table',
        'user_table',
      ];

      for (final required in requiredTables) {
        if (!tableNames.contains(required)) {
          return BackupValidationResult.invalid(
            'Geçersiz PGYS yedek dosyası ("$required" tablosu bulunamadı).',
          );
        }
      }

      // 3. İsteğe bağlı kayıt sayısı tespiti
      int? personnelCount;
      int? userCount;
      int? taskCount;
      int? leaveCount;

      try {
        final pRes = tempDb.select('SELECT COUNT(*) AS c FROM personnel_table;');
        personnelCount = pRes.first['c'] as int?;
        final uRes = tempDb.select('SELECT COUNT(*) AS c FROM user_table;');
        userCount = uRes.first['c'] as int?;
        final tRes = tempDb.select('SELECT COUNT(*) AS c FROM task_table;');
        taskCount = tRes.first['c'] as int?;
        final lRes = tempDb.select('SELECT COUNT(*) AS c FROM leave_table;');
        leaveCount = lRes.first['c'] as int?;
      } catch (_) {
        // Kayıt sayımı opsiyoneldir
      }

      return BackupValidationResult.valid(
        personnelCount: personnelCount,
        userCount: userCount,
        taskCount: taskCount,
        leaveCount: leaveCount,
        fileSizeBytes: fileSize,
        fileModifiedDate: stat.modified,
      );
    } on sq.SqliteException catch (e) {
      return BackupValidationResult.invalid(
        'Bozuk veya geçersiz SQLite dosyası: ${e.message}',
      );
    } catch (e) {
      return BackupValidationResult.invalid('Dosya okunamadı: $e');
    } finally {
      tempDb?.dispose();
    }
  }

  /// Returns the File object pointing to the safety snapshot location.
  static Future<File> getSafetySnapshotFile([File? activeDbFile]) async {
    final dbFile = activeDbFile ?? await AppDatabase.databaseFile();
    return File(p.join(dbFile.parent.path, safetySnapshotFileName));
  }

  /// Checks if a valid pre-restore safety snapshot currently exists.
  Future<bool> hasSafetySnapshot([File? activeDbFile]) async {
    final file = await getSafetySnapshotFile(activeDbFile);
    return file.exists();
  }

  /// Creates a safety snapshot of the currently active database before restore.
  Future<File?> createSafetySnapshot({File? sourceDbFile}) async {
    final dbFile = sourceDbFile ?? await AppDatabase.databaseFile();
    if (!await dbFile.exists()) return null;

    final snapshotFile = await getSafetySnapshotFile(dbFile);
    if (await snapshotFile.exists()) {
      await snapshotFile.delete();
    }

    final normalizedPath = snapshotFile.path.replaceAll(r'\', '/');
    try {
      await database.customStatement('VACUUM INTO ?', [normalizedPath]);
      return snapshotFile;
    } catch (_) {
      return await dbFile.copy(snapshotFile.path);
    }
  }

  /// Rollbacks the database to the pre-restore safety snapshot.
  Future<bool> rollbackSafetySnapshot({File? targetDbFile}) async {
    final dest = targetDbFile ?? await AppDatabase.databaseFile();
    final snapshotFile = await getSafetySnapshotFile(dest);

    if (!await snapshotFile.exists()) {
      throw StateError('Geri dönülecek güvenlik yedeği dosyası bulunamadı.');
    }

    final validation = await validateBackupFile(snapshotFile.path);
    if (!validation.isValid) {
      throw StateError('Güvenlik yedeği dosyası bozuk veya geçersiz.');
    }

    await database.close();

    for (final suffix in ['', '-wal', '-shm']) {
      final extra = File('${dest.path}$suffix');
      if (await extra.exists()) {
        await extra.delete();
      }
    }

    await snapshotFile.copy(dest.path);
    return true;
  }

  /// Veritabanını tamamen sıfırlar (fabrika ayarlarına döndürür):
  /// 1. Güvenlik yedeği alır
  /// 2. Tüm tabloları boşaltır
  /// 3. Yalnızca varsayılan kurumsal admin kullanıcısını oluşturur
  Future<void> factoryReset({File? sourceDbFile, bool createSnapshot = true}) async {
    if (createSnapshot) {
      try {
        await createSafetySnapshot(sourceDbFile: sourceDbFile);
      } catch (_) {
        // Platform bağımlı ortamlarda snapshot alınamazsa sıfırlamayı engelleme
      }
    }
    await database.customStatement('PRAGMA foreign_keys = OFF;');
    try {
      await database.customStatement('DELETE FROM task_personnel_table;');
      await database.customStatement('DELETE FROM task_table;');
      await database.customStatement('DELETE FROM leave_table;');
      await database.customStatement('DELETE FROM personnel_history_table;');
      await database.customStatement('DELETE FROM personnel_table;');
      await database.customStatement('DELETE FROM user_table;');
      await database.customStatement('DELETE FROM settings_table;');
    } finally {
      await database.customStatement('PRAGMA foreign_keys = ON;');
    }
    await SeedDatabase(database).seed();
  }

  /// Exports a clean SQLite backup via VACUUM INTO.
  /// If [customTargetPath] is provided, saves directly to it without opening file dialog.
  Future<String?> exportBackup({String? customTargetPath}) async {
    String? destPath = customTargetPath;

    if (destPath == null) {
      final suggestedName =
          'pgys-yedek-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.sqlite';

      final location = await getSaveLocation(
        suggestedName: suggestedName,
        confirmButtonText: 'Yedekle',
        acceptedTypeGroups: const [
          XTypeGroup(label: 'SQLite', extensions: ['sqlite', 'db']),
        ],
      );

      if (location == null) return null;
      destPath = location.path;
    }

    destPath = _ensureExtension(destPath, 'sqlite');
    final dest = File(destPath);
    if (await dest.exists()) {
      await dest.delete();
    }

    final sqlitePath = dest.path.replaceAll(r'\', '/');
    await database.customStatement('VACUUM INTO ?', [sqlitePath]);
    return dest.path;
  }

  /// Default directory for backups.
  Future<Directory> getDefaultBackupDirectory() async {
    final dbFile = await AppDatabase.databaseFile();
    final dir = Directory(p.join(dbFile.parent.path, 'backups'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Lists all valid backups in the specified or default directory, newest first.
  Future<List<BackupFileInfo>> listAvailableBackups({
    Directory? directory,
    String? customPath,
  }) async {
    final dir = directory ??
        (customPath != null
            ? Directory(customPath)
            : await getDefaultBackupDirectory());

    if (!await dir.exists()) return [];

    final entities = await dir.list().toList();
    final files = entities
        .whereType<File>()
        .where((file) =>
            file.path.endsWith('.sqlite') || file.path.endsWith('.db'))
        .toList();

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files.map((file) {
      final stat = file.statSync();
      return BackupFileInfo(
        path: file.path,
        name: p.basename(file.path),
        sizeBytes: stat.size,
        modifiedDate: stat.modified,
      );
    }).toList();
  }

  /// Prunes old backups in [directory] when total count exceeds [maxRetention].
  Future<int> pruneOldBackups({
    required Directory directory,
    required int maxRetention,
  }) async {
    if (!await directory.exists() || maxRetention <= 0) return 0;

    final entities = await directory.list().toList();
    final files = entities
        .whereType<File>()
        .where((file) {
          final name = p.basename(file.path).toLowerCase();
          return (name.endsWith('.sqlite') || name.endsWith('.db')) &&
              !name.contains('safety_backup');
        })
        .toList();

    if (files.length <= maxRetention) return 0;

    // En yeniden en eskiye sırala
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    int deleted = 0;
    for (int i = maxRetention; i < files.length; i++) {
      try {
        await files[i].delete();
        deleted++;
      } catch (_) {}
    }
    return deleted;
  }

  /// Executes automated backup if configured and interval has passed.
  Future<AutoBackupResult> performAutoBackupIfNeeded({
    required AppSettings settings,
    String? customDirectory,
    DateTime? now,
  }) async {
    if (!settings.autoBackupEnabled) {
      return const AutoBackupResult(
        success: false,
        message: 'Otomatik yedekleme pasif.',
      );
    }

    final currentTime = now ?? DateTime.now();
    if (settings.lastBackupDate != null) {
      final diffHours = currentTime.difference(settings.lastBackupDate!).inHours;
      if (diffHours < settings.autoBackupIntervalHours) {
        return const AutoBackupResult(
          success: false,
          message: 'Yedekleme periyodu henüz dolmadı.',
        );
      }
    }

    final targetDir = customDirectory != null
        ? Directory(customDirectory)
        : (settings.backupDirectoryPath != null
            ? Directory(settings.backupDirectoryPath!)
            : await getDefaultBackupDirectory());

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final timestampStr = DateFormat('yyyyMMdd-HHmmss').format(currentTime);
    final targetFilePath = p.join(
      targetDir.path,
      'pgys-otomatik-yedek-$timestampStr.sqlite',
    );

    final exportedPath = await exportBackup(customTargetPath: targetFilePath);
    if (exportedPath == null) {
      return const AutoBackupResult(
        success: false,
        message: 'Otomatik yedek dosyası oluşturulamadı.',
      );
    }

    final prunedCount = await pruneOldBackups(
      directory: targetDir,
      maxRetention: settings.maxBackupRetentionCount,
    );

    return AutoBackupResult(
      success: true,
      backupPath: exportedPath,
      timestamp: currentTime,
      prunedCount: prunedCount,
      message: 'Otomatik yedek başarıyla alındı.',
    );
  }

  /// Opens desktop file picker to select a backup file.
  Future<String?> pickBackupFile() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'SQLite', extensions: ['sqlite', 'db']),
      ],
    );
    return file?.path;
  }

  /// Opens directory picker for custom backup folder.
  Future<String?> pickBackupDirectory() async {
    return await getDirectoryPath(
      confirmButtonText: 'Klasörü Seç',
    );
  }

  /// Restores database from [sourcePath] after validating and taking a safety snapshot.
  Future<void> restoreBackup(
    String sourcePath, {
    File? targetDbFile,
    bool skipSnapshot = false,
  }) async {
    final validation = await validateBackupFile(sourcePath);
    if (!validation.isValid) {
      throw StateError(
        validation.errorMessage ?? 'Seçilen dosya geçerli bir PGYS yedeği değil.',
      );
    }

    final dest = targetDbFile ?? await AppDatabase.databaseFile();

    // Geri yükleme öncesi otomatik güvenlik yedeği al
    if (!skipSnapshot) {
      await createSafetySnapshot(sourceDbFile: dest);
    }

    await database.close();

    try {
      for (final suffix in ['', '-wal', '-shm']) {
        final extra = File('${dest.path}$suffix');
        if (await extra.exists()) {
          await extra.delete();
        }
      }

      final source = File(sourcePath);
      await source.copy(dest.path);
    } catch (e) {
      // Restore başarısız olursa, güvenlik yedeği varsa geri yüklemeyi dene
      if (!skipSnapshot) {
        try {
          final snapshotFile = await getSafetySnapshotFile(dest);
          if (await snapshotFile.exists()) {
            await snapshotFile.copy(dest.path);
          }
        } catch (_) {}
      }
      rethrow;
    }
  }

  static String _ensureExtension(String path, String extension) {
    final normalized = '.$extension';
    if (p.extension(path).toLowerCase() == normalized) {
      return path;
    }
    return '$path$normalized';
  }
}
