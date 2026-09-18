import 'package:flutter/material.dart';
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
          const TodayRosterCard(),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return const Column(
                  children: [
                    UpcomingTaskCard(),
                    SizedBox(height: AppSpacing.md),
                    RecentActivityCard(),
                  ],
                );
              }

              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: UpcomingTaskCard()),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: RecentActivityCard()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
