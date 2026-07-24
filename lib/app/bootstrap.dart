import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import '../core/database/seed_database.dart';
import '../core/database/app_database.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await SeedDatabase(getIt<AppDatabase>()).seed();
  runApp(ProviderScope(child: await builder()));
}
