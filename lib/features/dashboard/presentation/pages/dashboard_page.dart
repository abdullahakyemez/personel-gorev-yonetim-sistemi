import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/dashboard_stats_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/recent_activity_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/upcoming_tasks_card.dart';

import '../../../../core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(title: "Dashboard", subtitle: "Genel durum özeti"),
          const SizedBox(height: AppSpacing.xl),
          const DashboardStatsGrid(),

          const SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 450, child: RecentActivityCard()),
              const Expanded(child: RecentActivityCard()),
              const SizedBox(width: AppSpacing.sm),

              //SizedBox(height: 450, child: UpcomingTaskCard()),
              const Expanded(child: UpcomingTaskCard()),
            ],
          ),
        ],
      ),
    );
  }
}
