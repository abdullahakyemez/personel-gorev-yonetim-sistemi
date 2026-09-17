import 'package:flutter/material.dart';

/// PGYS Responsive Kırılım Noktaları ve Yardımcıları
class AppBreakpoints {
  AppBreakpoints._();

  /// Mobil genişlik eşiği (< 768px: Akıllı telefonlar ve dikey kompakt ekranlar)
  static const double mobile = 768.0;

  /// Tablet genişlik eşiği (768px - 1100px: Küçük dizüstüler ve tabletler)
  static const double tablet = 1100.0;

  /// Masaüstü genişlik eşiği (>= 1100px: Geniş ekranlar)
  static const double desktop = 1100.0;

  /// Ekran mobil mi?
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  /// Ekran tablet mi?
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  /// Ekran masaüstü / geniş ekran mı?
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  /// Belirli bir kısıt (constraints) mobil mi?
  static bool isNarrow(BoxConstraints constraints) =>
      constraints.maxWidth < mobile;
}
