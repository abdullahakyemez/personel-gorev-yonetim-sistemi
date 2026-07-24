import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/pgys_skeleton.dart';
import '../../../core/widgets/pgys_card.dart';

class PGYSTableLoading extends StatelessWidget {
  const PGYSTableLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      child: Column(
        children: [
          /// Header
          Row(
            children: List.generate(
              6,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: PGYSSkeleton(height: 18),
                ),
              ),
            ),
          ),

          const Divider(),

          ...List.generate(
            8,
            (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: List.generate(
                  6,
                  (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: PGYSSkeleton(height: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
