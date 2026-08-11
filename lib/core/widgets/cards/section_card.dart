import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final double? height;
  final VoidCallback? onTap;
  final bool scrollable;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.height,
    this.scrollable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      onTap: onTap,
      child: SizedBox(
        height: height,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ?trailing,
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            const Divider(),

            const SizedBox(height: AppSpacing.sm),
            scrollable ? Expanded(child: child) : child,
          ],
        ),
      ),
    );
  }
}
