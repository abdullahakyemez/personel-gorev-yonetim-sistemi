import 'package:flutter/material.dart';

/// Kurumsal PGYS modül başlık banner bileşeni.
/// Tüm modüllerde (Personel, Görev, İzin, Raporlar, Kullanıcı Yönetimi, Ayarlar)
/// standart #0F2027 - #1E3740 degrade zemin, 14px köşe yuvarlatma ve
/// #4DD0E1 vurgulu ikon kutusu ile ortak tasarım dilini garanti eder.
class PGYSModuleBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? statusText;
  final Widget? trailing;
  final Color iconColor;
  final EdgeInsetsGeometry padding;

  const PGYSModuleBanner({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.statusText,
    this.trailing,
    this.iconColor = const Color(0xFF4DD0E1),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF1E3740),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          final leadingAndTitle = Row(
            mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          if (isNarrow && (statusText != null || trailing != null)) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                leadingAndTitle,
                if (statusText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    statusText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: 12),
                  trailing!,
                ],
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: leadingAndTitle),
              if (statusText != null) ...[
                const SizedBox(width: 12),
                Text(
                  statusText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: 14),
                trailing!,
              ],
            ],
          );
        },
      ),
    );
  }
}
