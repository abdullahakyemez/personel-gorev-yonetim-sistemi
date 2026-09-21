import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/dashboard_stats_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/recent_activity_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/today_roster_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/upcoming_tasks_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardStatsGrid(),
          const SizedBox(height: AppSpacing.lg),
          const TodayRosterCard()
              .animate()
              .fadeIn(duration: AppDurations.normal)
              .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    const UpcomingTaskCard()
                        .animate()
                        .fadeIn(duration: AppDurations.normal)
                        .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad),
                    const SizedBox(height: AppSpacing.md),
                    const RecentActivityCard()
                        .animate()
                        .fadeIn(duration: AppDurations.normal)
                        .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: const UpcomingTaskCard()
                        .animate()
                        .fadeIn(duration: AppDurations.normal)
                        .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: const RecentActivityCard()
                        .animate()
                        .fadeIn(duration: AppDurations.normal)
                        .slideY(begin: 0.1, duration: AppDurations.normal, curve: Curves.easeOutQuad),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
