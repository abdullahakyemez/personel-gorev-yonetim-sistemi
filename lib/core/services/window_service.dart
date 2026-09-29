import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';

/// Masaüstü (Windows, macOS, Linux) pencere boyutlandırma ve yönetim servisi.
///
/// Giriş (Login) ekranında pencerenin sabit, odaklanmış ve ekranın ortasında
/// panel boyutunda açılmasını; oturum açıldığında ise tam masaüstü çalışma
/// boyutuna genişletilerek yeniden boyutlandırılabilir hale gelmesini yönetir.
class WindowService {
  WindowService._();

  static const Size loginSize = Size(480, 720);
  static const Size appSize = Size(1280, 800);
  static const Size appMinSize = Size(1024, 640);
  static const Size loginMinSize = Size(420, 560);

  /// Uygulama ilk başlatıldığında pencere yöneticisini başlatır.
  static Future<void> initialize() async {
    if (kIsWeb) return;
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) return;

    try {
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(
        size: loginSize,
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setResizable(false);
        await windowManager.setMaximizable(false);
        await windowManager.show();
        await windowManager.focus();
      });
    } catch (_) {
      // Test ortamlarında veya native pencere yöneticisi bulunmayan durumlarda
    }
  }

  /// Pencereyi Login ekranı boyutuna getirir (Sabit boyut, ortalanmış, boyutlandırılamaz, başlıklı).
  static Future<void> setToLoginSize() async {
    if (kIsWeb) return;
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) return;

    try {
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      await windowManager.setMinimumSize(loginMinSize);
      await windowManager.setResizable(false);
      await windowManager.setMaximizable(false);
      await windowManager.setSize(loginSize);
      await windowManager.center();
    } catch (_) {
      // Test ortamlarında veya native pencere yöneticisi bulunmayan durumlarda
    }
  }

  /// Pencereyi Ana Uygulama / Dashboard boyutuna getirir (Genişletilebilir, serbest boyut, başlıklı).
  static Future<void> setToAppSize() async {
    if (kIsWeb) return;
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) return;

    try {
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      await windowManager.setResizable(true);
      await windowManager.setMaximizable(true);
      await windowManager.setMinimumSize(appMinSize);
      await windowManager.setSize(appSize);
      await windowManager.center();
    } catch (_) {
      // Test ortamlarında veya native pencere yöneticisi bulunmayan durumlarda
    }
  }

  /// Uygulamayı tamamen sonlandırır ve kapatır.
  static Future<void> closeApp() async {
    if (kIsWeb) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        if (getIt.isRegistered<AppDatabase>()) {
          await getIt<AppDatabase>().close();
        }
      } catch (_) {
        // Veritabanı kapatma hatası olsa bile çıkışı engelleme
      }
      exit(0);
    } else {
      await SystemNavigator.pop();
    }
  }
}
