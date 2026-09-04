enum AppThemeMode { system, light, dark }

class AppSettings {
  final String appName;
  final String dateFormat;
  final AppThemeMode themeMode;

  const AppSettings({
    required this.appName,
    required this.dateFormat,
    required this.themeMode,
  });

  factory AppSettings.defaults() {
    return const AppSettings(
      appName: 'Personel ve Görev Yönetim Sistemi',
      dateFormat: 'dd.MM.yyyy',
      themeMode: AppThemeMode.system,
    );
  }

  AppSettings copyWith({
    String? appName,
    String? dateFormat,
    AppThemeMode? themeMode,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      dateFormat: dateFormat ?? this.dateFormat,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
