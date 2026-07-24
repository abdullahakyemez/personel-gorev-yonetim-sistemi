import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'pgys_button_type.dart';

class PGYSButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final PGYSButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool enabled;

  const PGYSButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = PGYSButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.enabled = true,
  });

  ButtonStyle _buildButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,

      minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
    );
  }

  ButtonStyle _buttonStyle() {
    switch (type) {
      case PGYSButtonType.primary:
        return _buildButtonStyle(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: Colors.white,
        );

      case PGYSButtonType.secondary:
        return _buildButtonStyle(
          backgroundColor: AppColors.secondaryButton,
          foregroundColor: AppColors.primary,
        );

      case PGYSButtonType.danger:
        return _buildButtonStyle(
          backgroundColor: AppColors.dangerButton,
          foregroundColor: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: AppSizes.buttonHeight);
  }
}
