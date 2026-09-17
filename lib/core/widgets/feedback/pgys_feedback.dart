import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum PGYSFeedbackType {
  success,
  error,
  warning,
  info,
}

class PGYSFeedback {
  PGYSFeedback._();

  static void showSuccess(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: PGYSFeedbackType.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: PGYSFeedbackType.error,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: PGYSFeedbackType.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: PGYSFeedbackType.info,
      duration: duration,
    );
  }

  static void hide([BuildContext? context]) {
    final messenger = _getMessenger(context);
    messenger?.hideCurrentSnackBar();
  }

  static void show({
    BuildContext? context,
    required String message,
    String? title,
    required PGYSFeedbackType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = _getMessenger(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    final Color statusColor = switch (type) {
      PGYSFeedbackType.success => AppColors.success,
      PGYSFeedbackType.error => AppColors.danger,
      PGYSFeedbackType.warning => AppColors.warning,
      PGYSFeedbackType.info => AppColors.primary,
    };

    final IconData icon = switch (type) {
      PGYSFeedbackType.success => Icons.check_circle_outline_rounded,
      PGYSFeedbackType.error => Icons.error_outline_rounded,
      PGYSFeedbackType.warning => Icons.warning_amber_rounded,
      PGYSFeedbackType.info => Icons.info_outline_rounded,
    };

    double? screenWidth;
    if (context != null && context.mounted) {
      screenWidth = MediaQuery.maybeOf(context)?.size.width;
    }

    final bool isNarrow = screenWidth != null && screenWidth < 500;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: isNarrow ? null : 440,
        margin: isNarrow
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E232A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title.isNotEmpty) ...[
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      message,
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 12.5,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  messenger.hideCurrentSnackBar();
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static ScaffoldMessengerState? _getMessenger(BuildContext? context) {
    if (context != null && context.mounted) {
      return ScaffoldMessenger.maybeOf(context) ??
          rootScaffoldMessengerKey.currentState;
    }
    return rootScaffoldMessengerKey.currentState;
  }
}
