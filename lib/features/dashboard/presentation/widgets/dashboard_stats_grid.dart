import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/dashboard_stat_card_data.dart';

import '../../application/dashboard_statistics_provider.dart';
import 'dashboard_stat_card.dart';

class DashboardStatsGrid extends ConsumerWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(dashboardStatisticsProvider);

    return statisticsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Center(child: Text(e.toString())),

      data: (statistics) {
        final cards = [
          DashboardStatCardData(
            icon: Icons.group_outlined,
            title: "Toplam Personel",
            value: statistics.totalPersonnel.toString(),
            color: const Color(0xFF1E88E5),
          ),
          DashboardStatCardData(
            icon: Icons.verified_user_outlined,
            title: "Görevde",
            value: statistics.activePersonnel.toString(),
            color: const Color(0xFF00875A),
          ),
          DashboardStatCardData(
            icon: Icons.free_breakfast_outlined,
            title: "İstirahatli",
            value: statistics.restingPersonnel.toString(),
            color: const Color(0xFF0288D1),
          ),
          DashboardStatCardData(
            icon: Icons.flight_takeoff_rounded,
            title: "İzinli",
            value: statistics.leavePersonnel.toString(),
            color: const Color(0xFFE65100),
          ),
          DashboardStatCardData(
            icon: Icons.local_hospital_outlined,
            title: "Raporlu",
            value: statistics.sickReportPersonnel.toString(),
            color: const Color(0xFFD32F2F),
          ),
          DashboardStatCardData(
            icon: Icons.assignment_outlined,
            title: "Toplam Görev",
            value: statistics.totalTasks.toString(),
            color: const Color(0xFF7B1FA2),
          ),
          DashboardStatCardData(
            icon: Icons.access_time_filled_rounded,
            title: "Aktif Görev",
            value: statistics.inProgressTasks.toString(),
            color: const Color(0xFFF57C00),
          ),
          DashboardStatCardData(
            icon: Icons.check_circle_outline_rounded,
            title: "Tamamlanan",
            value: statistics.completedTasks.toString(),
            color: const Color(0xFF00897B),
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = 8;
            if (constraints.maxWidth < 600) {
              columns = 2;
            } else if (constraints.maxWidth < 1150) {
              columns = 4;
            }

            final spacing = columns == 8 ? 10.0 : AppSpacing.md;
            final cardWidth =
                (constraints.maxWidth - (columns - 1) * spacing) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: cards.map((card) {
                return SizedBox(
                  width: cardWidth,
                  child: DashboardStatCard(data: card),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
