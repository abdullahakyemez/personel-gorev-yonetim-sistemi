import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class PGYSConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<String>? details;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final IconData? icon;

  const PGYSConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.details,
    this.confirmText = 'Sil',
    this.cancelText = 'Vazgeç',
    this.isDestructive = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dialogIcon = icon ??
        (isDestructive
            ? Icons.warning_amber_rounded
            : Icons.help_outline_rounded);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kurumsal Başlık Bandı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDestructive
                          ? const Color(0xFFD32F2F).withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dialogIcon,
                      color: isDestructive
                          ? const Color(0xFFFF5252)
                          : const Color(0xFF4DD0E1),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    tooltip: 'Kapat',
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ),

            // Gövde Alanı
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  if (details != null && details!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDestructive
                            ? colorScheme.errorContainer.withValues(alpha: 0.15)
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDestructive
                              ? colorScheme.error.withValues(alpha: 0.2)
                              : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İlişkili veriler:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDestructive
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ...details!.map(
                            (detail) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• ',
                                    style: TextStyle(
                                      color: isDestructive
                                          ? colorScheme.error
                                          : colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      detail,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isDestructive) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Bu işlem geri alınamaz.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error.withValues(alpha: 0.85),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(cancelText),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: isDestructive
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF0F2027),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        icon: Icon(
                          isDestructive ? Icons.delete_outline : Icons.check,
                          size: 18,
                        ),
                        label: Text(
                          confirmText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showPGYSConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  List<String>? details,
  String confirmText = 'Sil',
  String cancelText = 'Vazgeç',
  bool isDestructive = true,
  IconData? icon,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => PGYSConfirmDialog(
      title: title,
      message: message,
      details: details,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      icon: icon,
    ),
  );
}
