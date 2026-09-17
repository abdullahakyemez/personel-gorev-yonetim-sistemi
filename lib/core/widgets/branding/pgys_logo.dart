import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';

enum PGYSLogoVariant {
  /// Yalnızca amblem (sidebar daraltılmış, küçük simgeler vb.)
  compact,

  /// Amblem ve sağında yatay tipografi (sidebar açık, topbar vb.)
  horizontal,

  /// Amblem üstte, tipografi altta dikey hizalı (giriş ekranı, hakkında paneli vb.)
  stacked,
}

class PGYSLogo extends StatelessWidget {
  final double size;
  final PGYSLogoVariant variant;
  final bool showSubtitle;
  final Color? primaryColor;
  final Color? accentColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const PGYSLogo({
    super.key,
    this.size = 40,
    this.variant = PGYSLogoVariant.horizontal,
    this.showSubtitle = true,
    this.primaryColor,
    this.accentColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectivePrimary = primaryColor ??
        (isDark ? theme.colorScheme.primary : AppColors.primary);
    final effectiveAccent = accentColor ?? const Color(0xFFFFB300);

    final emblem = SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.18),
        child: Image.asset(
          'assets/images/logo_icon.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => CustomPaint(
            painter: _PGYSEmblemPainter(
              primaryColor: effectivePrimary,
              accentColor: effectiveAccent,
              isDark: isDark,
            ),
          ),
        ),
      ),
    );

    if (variant == PGYSLogoVariant.compact) {
      return emblem;
    }

    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontSize: variant == PGYSLogoVariant.stacked ? size * 0.38 : size * 0.42,
        );

    final effectiveSubtitleStyle = subtitleStyle ??
        theme.textTheme.labelSmall?.copyWith(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          fontSize: variant == PGYSLogoVariant.stacked ? size * 0.17 : size * 0.22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        );

    if (variant == PGYSLogoVariant.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emblem,
          SizedBox(width: size * 0.28),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PGYS',
                  style: effectiveTitleStyle,
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Personel & Görev Yönetim Sistemi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: effectiveSubtitleStyle,
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    // Stacked (Dikey) varyant
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        SizedBox(height: size * 0.18),
        Text(
          'PGYS',
          style: effectiveTitleStyle,
          textAlign: TextAlign.center,
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'Personel ve Görev Yönetim Sistemi',
            textAlign: TextAlign.center,
            style: effectiveSubtitleStyle,
          ),
        ],
      ],
    );
  }
}

class _PGYSEmblemPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool isDark;

  _PGYSEmblemPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Dış Gölge ve Kalkan Yolu (Outer Shield Path)
    final shieldPath = Path();
    shieldPath.moveTo(w * 0.5, h * 0.02);
    // Üst sağ köşe
    shieldPath.quadraticBezierTo(w * 0.85, h * 0.03, w * 0.94, h * 0.16);
    // Sağ kenar
    shieldPath.quadraticBezierTo(w * 0.96, h * 0.52, w * 0.5, h * 0.98);
    // Sol kenar
    shieldPath.quadraticBezierTo(w * 0.04, h * 0.52, w * 0.06, h * 0.16);
    // Üst sol köşe
    shieldPath.quadraticBezierTo(w * 0.15, h * 0.03, w * 0.5, h * 0.02);
    shieldPath.close();

    // Dış gölge
    canvas.drawShadow(
      shieldPath,
      isDark ? Colors.black : Colors.blueGrey.withValues(alpha: 0.5),
      w * 0.08,
      false,
    );

    // Kalkan Degrade Dolgusu (Gövde)
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1E3A8A), // Koyu Polis Laciverti
          primaryColor,
          const Color(0xFF0F172A), // Gece mavisi / derinlik
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(shieldPath, bodyPaint);

    // 2. Altın Çerçeve (Gold Border)
    final goldBorderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFE082), // Parlak altın
          accentColor,             // Klasik altın
          const Color(0xFFB45309), // Bronz/koyu altın
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, w * 0.05)
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(shieldPath, goldBorderPaint);

    // 3. İç İnce Çerçeve (Inner Contour)
    final innerPath = Path();
    innerPath.moveTo(w * 0.5, h * 0.10);
    innerPath.quadraticBezierTo(w * 0.80, h * 0.11, w * 0.86, h * 0.22);
    innerPath.quadraticBezierTo(w * 0.88, h * 0.50, w * 0.5, h * 0.88);
    innerPath.quadraticBezierTo(w * 0.12, h * 0.50, w * 0.14, h * 0.22);
    innerPath.quadraticBezierTo(w * 0.20, h * 0.11, w * 0.5, h * 0.10);
    innerPath.close();

    final innerBorderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, w * 0.02);
    canvas.drawPath(innerPath, innerBorderPaint);

    // 4. Merkez Görev Yıldızı ve Rozet (Central Star)
    _drawStar(
      canvas,
      Offset(w * 0.5, h * 0.44),
      outerRadius: w * 0.22,
      innerRadius: w * 0.09,
      points: 8,
      fillColor: const Color(0xFFFFD54F),
      contourColor: const Color(0xFFB45309),
    );

    // 5. Yıldızın Merkezindeki Koruma Halkası ve Hilal-Yıldız Dokunuşu
    final centerCirclePaint = Paint()
      ..color = const Color(0xFF0D47A1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.08, centerCirclePaint);

    final centerRingPaint = Paint()
      ..color = const Color(0xFFFFE082)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, w * 0.025);
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.08, centerRingPaint);

    // Mini Merkez Noktası / Akrep Sembolü
    final corePointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.03, corePointPaint);

    // 6. Alt Şerit / Çift Defne Vurgusu (Bottom Chevron / Wings)
    final chevronPath = Path();
    chevronPath.moveTo(w * 0.30, h * 0.72);
    chevronPath.quadraticBezierTo(w * 0.5, h * 0.81, w * 0.70, h * 0.72);
    chevronPath.quadraticBezierTo(w * 0.5, h * 0.77, w * 0.30, h * 0.72);
    chevronPath.close();

    final chevronPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawPath(chevronPath, chevronPaint);
  }

  void _drawStar(
    Canvas canvas,
    Offset center, {
    required double outerRadius,
    required double innerRadius,
    required int points,
    required Color fillColor,
    required Color contourColor,
  }) {
    final starPath = Path();
    final step = math.pi / points;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerRadius : innerRadius;
      final angle = i * step - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    final starFill = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          fillColor,
          const Color(0xFFF59E0B),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath, starFill);

    final starBorder = Paint()
      ..color = contourColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, outerRadius * 0.08);
    canvas.drawPath(starPath, starBorder);
  }

  @override
  bool shouldRepaint(covariant _PGYSEmblemPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark;
  }
}
