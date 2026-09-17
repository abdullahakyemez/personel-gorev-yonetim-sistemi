import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/branding/pgys_logo.dart';

class AppSidebarHeader extends StatelessWidget {
  final bool isExpanded;
  final String header;
  final String text;

  const AppSidebarHeader({
    super.key,
    required this.isExpanded,
    this.header = "PGYS",
    this.text = "Personel ve Görev Yönetim Sistemi",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
      child: isExpanded
          ? const PGYSLogo(
              variant: PGYSLogoVariant.horizontal,
              size: 38,
            )
          : const PGYSLogo(
              variant: PGYSLogoVariant.compact,
              size: 32,
            ),
    );
  }
}
