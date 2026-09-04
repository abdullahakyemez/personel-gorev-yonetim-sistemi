import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';

class SettingsMapper {
  static AppSettings toDomain(SettingsTableData data) {
    return AppSettings(
      appName: data.appName,
      dateFormat: data.dateFormat,
      themeMode: AppThemeMode.values.firstWhere(
        (mode) => mode.name == data.themeMode,
        orElse: () => AppThemeMode.system,
      ),
    );
  }

  static SettingsTableCompanion toCompanion(AppSettings settings) {
    return SettingsTableCompanion.insert(
      appName: settings.appName,
      dateFormat: settings.dateFormat,
      themeMode: settings.themeMode.name,
    );
  }
}
