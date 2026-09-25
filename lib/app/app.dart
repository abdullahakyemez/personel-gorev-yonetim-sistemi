import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/router/app_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_theme.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';

class PGYSApp extends ConsumerWidget {
  const PGYSApp({super.key});

  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;

      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final settings = settingsAsync.value;

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,

      debugShowCheckedModeBanner: false,

      title: settings != null && settings.appName.isNotEmpty
          ? settings.appName
          : 'PGYS - Personel ve Görev Yönetimi Sistemi',

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: _getThemeMode(settings?.themeMode ?? AppThemeMode.system),

      locale: const Locale('tr', 'TR'),
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('tr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
