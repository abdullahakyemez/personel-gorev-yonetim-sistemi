import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'app_database.dart';

/// Riverpod ortamında AppDatabase erişimini ve mocklanabilirliğini sağlayan ana provider.
final databaseProvider = Provider<AppDatabase>((ref) {
  if (getIt.isRegistered<AppDatabase>()) {
    return getIt<AppDatabase>();
  }
  throw StateError(
    'AppDatabase henüz başlatılmadı. Lütfen setupLocator() çalıştırıldığından veya ProviderScope üzerinden override edildiğinden emin olun.',
  );
});

/// Riverpod ortamında SharedPreferences erişimini sağlayan provider.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  if (getIt.isRegistered<SharedPreferences>()) {
    return getIt<SharedPreferences>();
  }
  throw StateError(
    'SharedPreferences henüz başlatılmadı. Lütfen setupLocator() çalıştırıldığından emin olun.',
  );
});
