import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';

class PGYSTableHeader extends StatelessWidget {
  final List<Widget> children;

  const PGYSTableHeader({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: children),
    );
  }
}
