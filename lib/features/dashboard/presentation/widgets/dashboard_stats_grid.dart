import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'dashboard_stats_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/data/mock/dashboard_stat_data.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: dashboardStats.map((stat) {
        return SizedBox(
          width: 210,
          child: DashboardStatCard(
            icon: stat.icon,
            title: stat.title,
            value: stat.value,
            subtitle: stat.subtitle,
          ),
        );
      }).toList(),
    );
  }
}
