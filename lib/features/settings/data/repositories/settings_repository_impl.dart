import 'package:shared_preferences/shared_preferences.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/repositories/settings_repository.dart';

import '../mapper/settings_mapper.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase database;
  final SharedPreferences? _prefs;

  static const String keyInstitutionTitle = 'pgys_setting_institution_title';
  static const String keyAgencyCity = 'pgys_setting_agency_city';
  static const String keyAutoBackupEnabled = 'pgys_setting_auto_backup_enabled';
  static const String keyAutoBackupIntervalHours =
      'pgys_setting_auto_backup_interval';
  static const String keyBackupDirectoryPath = 'pgys_setting_backup_dir_path';
  static const String keyLastBackupDate = 'pgys_setting_last_backup_date';
  static const String keyMaxBackupRetentionCount =
      'pgys_setting_max_backup_retention';

  SettingsRepositoryImpl(this.database, [SharedPreferences? prefs])
      : _prefs = prefs ??
            (getIt.isRegistered<SharedPreferences>()
                ? getIt<SharedPreferences>()
                : null);

  @override
  Future<AppSettings> getSettings() async {
    final query = database.select(database.settingsTable)..limit(1);

    final result = await query.getSingleOrNull();

    AppSettings base;
    if (result == null) {
      final defaults = AppSettings.defaults();
      await saveSettings(defaults);
      base = defaults;
    } else {
      base = SettingsMapper.toDomain(result);
    }

    if (_prefs == null) return base;

    final institutionTitle =
        _prefs.getString(keyInstitutionTitle) ?? base.institutionTitle;
    final agencyCity = _prefs.getString(keyAgencyCity) ?? base.agencyCity;
    final autoBackupEnabled =
        _prefs.getBool(keyAutoBackupEnabled) ?? base.autoBackupEnabled;
    final autoBackupIntervalHours = _prefs.getInt(keyAutoBackupIntervalHours) ??
        base.autoBackupIntervalHours;
    final backupDirectoryPath =
        _prefs.getString(keyBackupDirectoryPath) ?? base.backupDirectoryPath;

    DateTime? lastBackupDate = base.lastBackupDate;
    final lastBackupRaw = _prefs.getString(keyLastBackupDate);
    if (lastBackupRaw != null) {
      lastBackupDate = DateTime.tryParse(lastBackupRaw);
    }

    final maxBackupRetentionCount =
        _prefs.getInt(keyMaxBackupRetentionCount) ??
            base.maxBackupRetentionCount;

    return base.copyWith(
      institutionTitle: institutionTitle,
      agencyCity: agencyCity,
      autoBackupEnabled: autoBackupEnabled,
      autoBackupIntervalHours: autoBackupIntervalHours,
      backupDirectoryPath: backupDirectoryPath,
      lastBackupDate: lastBackupDate,
      maxBackupRetentionCount: maxBackupRetentionCount,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final existing = await (database.select(
      database.settingsTable,
    )..limit(1)).getSingleOrNull();

    final companion = SettingsMapper.toCompanion(settings);

    if (existing == null) {
      await database.into(database.settingsTable).insert(companion);
    } else {
      await (database.update(
        database.settingsTable,
      )..where((table) => table.id.equals(existing.id))).write(companion);
    }

    if (_prefs != null) {
      await _prefs.setString(keyInstitutionTitle, settings.institutionTitle);
      await _prefs.setString(keyAgencyCity, settings.agencyCity);
      await _prefs.setBool(keyAutoBackupEnabled, settings.autoBackupEnabled);
      await _prefs.setInt(
          keyAutoBackupIntervalHours, settings.autoBackupIntervalHours);

      if (settings.backupDirectoryPath != null) {
        await _prefs.setString(
            keyBackupDirectoryPath, settings.backupDirectoryPath!);
      } else {
        await _prefs.remove(keyBackupDirectoryPath);
      }

      if (settings.lastBackupDate != null) {
        await _prefs.setString(
            keyLastBackupDate, settings.lastBackupDate!.toIso8601String());
      } else {
        await _prefs.remove(keyLastBackupDate);
      }

      await _prefs.setInt(
          keyMaxBackupRetentionCount, settings.maxBackupRetentionCount);
    }
  }
}
