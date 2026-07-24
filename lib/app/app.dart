import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/router/app_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_theme.dart';

class PGYSApp extends StatelessWidget {
  const PGYSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "PGYS",
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
