import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';

class PGYSTableRow extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final int index;
  final bool selected;

  const PGYSTableRow({
    super.key,
    required this.children,
    this.onTap,
    required this.index,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: AppColors.primary.withValues(alpha: 0.04),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.50)
              : index.isEven
              ? Colors.white
              : AppColors.background,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: children),
      ),
    );
  }
}
