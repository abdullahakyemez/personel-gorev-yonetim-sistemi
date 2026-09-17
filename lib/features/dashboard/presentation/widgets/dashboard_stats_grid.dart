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
            icon: Icons.people,
            title: "Toplam Personel",
            value: statistics.totalPersonnel.toString(),
            color: Colors.blue,
          ),

          DashboardStatCardData(
            icon: Icons.badge,
            title: "Görevde",
            value: statistics.activePersonnel.toString(),
            color: Colors.green,
          ),

          DashboardStatCardData(
            icon: Icons.person_off,
            title: "İstirahatli",
            value: statistics.restingPersonnel.toString(),
            color: Colors.grey,
          ),

          DashboardStatCardData(
            icon: Icons.assignment,
            title: "Toplam Görev",
            value: statistics.totalTasks.toString(),
            color: Colors.lightBlue,
          ),
          DashboardStatCardData(
            icon: Icons.assignment_late_rounded,
            title: "Aktif Görev",
            value: statistics.inProgressTasks.toString(),
            color: Colors.purple,
          ),
          DashboardStatCardData(
            icon: Icons.check_circle,
            title: "Tamamlanan",
            value: statistics.completedTasks.toString(),
            color: Colors.green,
          ),

          DashboardStatCardData(
            icon: Icons.local_hospital_rounded,
            title: "Raporlu Personel",
            value: statistics.sickReportPersonnel.toString(),
            color: Colors.orange,
          ),

          DashboardStatCardData(
            icon: Icons.home_rounded,
            title: "İzinli Personel",
            value: statistics.leavePersonnel.toString(),
            color: Colors.teal,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = 4;
            if (constraints.maxWidth < 640) {
              columns = 1;
            } else if (constraints.maxWidth < 1000) {
              columns = 2;
            }

            const spacing = AppSpacing.lg;
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
