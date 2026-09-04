import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/repositories/settings_repository.dart';

import '../mapper/settings_mapper.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase database;

  SettingsRepositoryImpl(this.database);

  @override
  Future<AppSettings> getSettings() async {
    final query = database.select(database.settingsTable)..limit(1);

    final result = await query.getSingleOrNull();

    if (result == null) {
      final defaults = AppSettings.defaults();

      await saveSettings(defaults);

      return defaults;
    }

    return SettingsMapper.toDomain(result);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final existing = await (database.select(
      database.settingsTable,
    )..limit(1)).getSingleOrNull();

    final companion = SettingsMapper.toCompanion(settings);

    if (existing == null) {
      await database.into(database.settingsTable).insert(companion);
      return;
    }

    await (database.update(
      database.settingsTable,
    )..where((table) => table.id.equals(existing.id))).write(companion);
  }
}
