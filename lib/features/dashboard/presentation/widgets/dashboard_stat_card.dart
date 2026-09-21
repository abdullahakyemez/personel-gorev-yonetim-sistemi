import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/dashboard_stat_card_data.dart';

class DashboardStatCard extends StatelessWidget {
  final DashboardStatCardData data;

  const DashboardStatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.color, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              data.value,
              style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ) ??
                  const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.normal)
        .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad);
  }
}
