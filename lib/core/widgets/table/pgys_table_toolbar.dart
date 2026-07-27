import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class PGYSTableToolbar extends StatelessWidget {
  final List<Widget> filters;
  final List<Widget> actions;

  const PGYSTableToolbar({
    super.key,
    this.filters = const [],
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 1100;

          if (desktop) {
            return Row(children: [...filters, const Spacer(), ...actions]);
          }

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [...filters, ...actions],
          );
        },
      ),
    );
  }
}
