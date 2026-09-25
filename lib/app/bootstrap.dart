import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import '../core/database/seed_database.dart';
import '../core/database/app_database.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');
  await setupLocator();
  // Kurumsal güvenlik standardı: Masaüstü uygulamasında her açılışta oturumu kapat,
  // kullanıcının kimlik doğrulamasıyla giriş yapmasını zorunlu tut.
  await getIt<AuthRepository>().logout();
  await SeedDatabase(getIt<AppDatabase>()).seed();
  runApp(ProviderScope(child: await builder()));
}
