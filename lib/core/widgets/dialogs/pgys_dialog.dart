import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class PGYSDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool scrollable;
  final IconData? icon;
  final String? subtitle;

  const PGYSDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.scrollable = true,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 780, maxWidth: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kurumsal Başlık Bandı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon ?? Icons.badge_outlined,
                      color: const Color(0xFF4DD0E1),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    tooltip: 'Kapat',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // İçerik Alanı
            if (scrollable)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: child,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: child,
              ),

            // Opsiyonel Aksiyon Barı
            if (actions != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
