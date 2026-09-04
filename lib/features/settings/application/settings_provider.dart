import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';

import '../data/repositories/settings_repository_impl.dart';
import '../domain/models/app_settings.dart';
import '../domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(getIt<AppDatabase>());
});

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late final SettingsRepository _repository;

  @override
  Future<AppSettings> build() async {
    _repository = ref.read(settingsRepositoryProvider);
    return _repository.getSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    try {
      await _repository.saveSettings(settings);
      state = AsyncData(settings);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
