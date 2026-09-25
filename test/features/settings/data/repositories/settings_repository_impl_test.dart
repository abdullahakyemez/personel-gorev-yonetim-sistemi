import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsRepositoryImpl Extended Persistence Tests', () {
    late AppDatabase database;
    late SettingsRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      database = AppDatabase(NativeDatabase.memory());
      repository = SettingsRepositoryImpl(database, prefs);
    });

    tearDown(() async {
      await database.close();
    });

    test('getSettings returns defaults when database and prefs are empty', () async {
      final settings = await repository.getSettings();

      expect(settings.appName, equals('Personel ve Görev Yönetim Sistemi'));
      expect(settings.dateFormat, equals('dd.MM.yyyy'));
      expect(settings.themeMode, equals(AppThemeMode.system));
      expect(settings.institutionTitle, equals('T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ'));
      expect(settings.agencyCity, equals('ANKARA'));
      expect(settings.autoBackupEnabled, isTrue);
      expect(settings.autoBackupIntervalHours, equals(24));
      expect(settings.maxBackupRetentionCount, equals(10));
      expect(settings.lastBackupDate, isNull);
      expect(settings.backupDirectoryPath, isNull);
    });

    test('saveSettings persists and retrieves basic and extended properties', () async {
      final customDate = DateTime(2026, 9, 17, 14, 30);
      final customSettings = const AppSettings(
        appName: 'Asayiş Şube PGYS',
        dateFormat: 'yyyy-MM-dd',
        themeMode: AppThemeMode.dark,
        institutionTitle: 'Ankara İl Emniyet Müdürlüğü Asayiş Şube Müdürlüğü',
        agencyCity: 'ÇANKAYA / ANKARA',
        autoBackupEnabled: true,
        autoBackupIntervalHours: 12,
        backupDirectoryPath: 'C:\\PGYS_Yedekler',
        lastBackupDate: null,
        maxBackupRetentionCount: 20,
      ).copyWith(lastBackupDate: customDate);

      await repository.saveSettings(customSettings);

      final loaded = await repository.getSettings();

      expect(loaded.appName, equals('Asayiş Şube PGYS'));
      expect(loaded.dateFormat, equals('yyyy-MM-dd'));
      expect(loaded.themeMode, equals(AppThemeMode.dark));
      expect(loaded.institutionTitle, equals('Ankara İl Emniyet Müdürlüğü Asayiş Şube Müdürlüğü'));
      expect(loaded.agencyCity, equals('ÇANKAYA / ANKARA'));
      expect(loaded.autoBackupEnabled, isTrue);
      expect(loaded.autoBackupIntervalHours, equals(12));
      expect(loaded.backupDirectoryPath, equals('C:\\PGYS_Yedekler'));
      expect(loaded.lastBackupDate, equals(customDate));
      expect(loaded.maxBackupRetentionCount, equals(20));
      expect(loaded.defaultAmirName, equals(''));
      expect(loaded.defaultAmirRank, equals('Büro Amiri'));
      expect(loaded.defaultAmirTitle, equals('Büro Amiri'));
    });

    test('saveSettings persists custom amir settings', () async {
      final customAmirSettings = AppSettings.defaults().copyWith(
        defaultAmirName: 'Murat YÜCEL',
        defaultAmirRank: 'Emniyet Amiri',
        defaultAmirTitle: 'Asayiş Büro Amiri',
      );

      await repository.saveSettings(customAmirSettings);
      final loaded = await repository.getSettings();

      expect(loaded.defaultAmirName, equals('Murat YÜCEL'));
      expect(loaded.defaultAmirRank, equals('Emniyet Amiri'));
      expect(loaded.defaultAmirTitle, equals('Asayiş Büro Amiri'));
    });

    test('saveSettings overwrites existing settings in database and prefs', () async {
      final initial = AppSettings.defaults();
      await repository.saveSettings(initial);

      final updated = initial.copyWith(
        appName: 'Güncel Sistem',
        institutionTitle: 'İstanbul İl Emniyet',
        agencyCity: 'KADIKÖY',
        autoBackupIntervalHours: 168,
      );
      await repository.saveSettings(updated);

      final loaded = await repository.getSettings();
      expect(loaded.appName, equals('Güncel Sistem'));
      expect(loaded.institutionTitle, equals('İstanbul İl Emniyet'));
      expect(loaded.agencyCity, equals('KADIKÖY'));
      expect(loaded.autoBackupIntervalHours, equals(168));
    });
  });
}
