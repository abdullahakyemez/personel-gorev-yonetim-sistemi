import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';

class PGYSTableCell extends StatelessWidget {
  final Widget child;
  final int flex;
  final Alignment alignment;
  final bool bold;
  final bool isHeader;
  final TextAlign textAlign;

  const PGYSTableCell({
    super.key,
    required this.child,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
    this.bold = false,
    this.isHeader = false,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: isHeader ? 14 : 13,
            fontWeight: isHeader
                ? FontWeight.w700
                : (bold ? FontWeight.w600 : FontWeight.w500),
            color: isHeader ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          child: child,
        ),
      ),
    );
  }
}
