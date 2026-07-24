import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class PGYSTableToolbar extends StatelessWidget {
  final Widget? leading;
  final List<Widget> actions;

  const PGYSTableToolbar({super.key, this.leading, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Wrap(
        spacing: 6,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        children: [
          if (leading != null) Expanded(child: leading!),

          if (actions.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.lg),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              //mainAxisSize: MainAxisSize.min,
              children: actions
                  .map(
                    (widget) => Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: widget,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
