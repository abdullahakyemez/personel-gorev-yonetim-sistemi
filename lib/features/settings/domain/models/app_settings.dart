enum AppThemeMode { system, light, dark }

class AppSettings {
  final String appName;
  final String dateFormat;
  final AppThemeMode themeMode;

  /// Kurum / Birim Başlığı (örn: T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ)
  final String institutionTitle;

  /// İl / İlçe veya Birim Bölgesi (örn: ANKARA)
  final String agencyCity;

  /// Otomatik yedekleme açık mı?
  final bool autoBackupEnabled;

  /// Otomatik yedekleme sıklığı (saat cinsinden, örn: 12, 24, 168)
  final int autoBackupIntervalHours;

  /// Özel yedekleme klasörü (null ise varsayılan sistem PGYS_Backups klasörü kullanılır)
  final String? backupDirectoryPath;

  /// En son alınan başarılı otomatik/manuel yedek zamanı
  final DateTime? lastBackupDate;

  /// Saklanacak maksimum yedek dosya sayısı (fazlası otomatik silinir)
  final int maxBackupRetentionCount;

  const AppSettings({
    required this.appName,
    required this.dateFormat,
    required this.themeMode,
    this.institutionTitle = 'T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ',
    this.agencyCity = 'ANKARA',
    this.autoBackupEnabled = true,
    this.autoBackupIntervalHours = 24,
    this.backupDirectoryPath,
    this.lastBackupDate,
    this.maxBackupRetentionCount = 10,
  });

  factory AppSettings.defaults() {
    return const AppSettings(
      appName: 'Personel ve Görev Yönetim Sistemi',
      dateFormat: 'dd.MM.yyyy',
      themeMode: AppThemeMode.system,
      institutionTitle: 'T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ',
      agencyCity: 'ANKARA',
      autoBackupEnabled: true,
      autoBackupIntervalHours: 24,
      maxBackupRetentionCount: 10,
    );
  }

  AppSettings copyWith({
    String? appName,
    String? dateFormat,
    AppThemeMode? themeMode,
    String? institutionTitle,
    String? agencyCity,
    bool? autoBackupEnabled,
    int? autoBackupIntervalHours,
    String? backupDirectoryPath,
    DateTime? lastBackupDate,
    int? maxBackupRetentionCount,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      dateFormat: dateFormat ?? this.dateFormat,
      themeMode: themeMode ?? this.themeMode,
      institutionTitle: institutionTitle ?? this.institutionTitle,
      agencyCity: agencyCity ?? this.agencyCity,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupIntervalHours:
          autoBackupIntervalHours ?? this.autoBackupIntervalHours,
      backupDirectoryPath: backupDirectoryPath ?? this.backupDirectoryPath,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      maxBackupRetentionCount:
          maxBackupRetentionCount ?? this.maxBackupRetentionCount,
    );
  }
}
