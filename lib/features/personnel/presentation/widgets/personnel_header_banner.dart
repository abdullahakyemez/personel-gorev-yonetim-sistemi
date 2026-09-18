import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_statistics_provider.dart';

class PersonnelHeaderBanner extends ConsumerWidget {
  const PersonnelHeaderBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatisticsProvider);

    final metricsText = statsAsync.when(
      data: (stats) {
        final total = stats.totalPersonnel;
        final onDuty = stats.activePersonnel;
        final onLeave = stats.leavePersonnel + stats.sickReportPersonnel;
        return 'Toplam Kadro: $total | Görevde: $onDuty | İzinli/Raporlu: $onLeave';
      },
      loading: () => 'Toplam Kadro: ... | Görevde: ... | İzinli/Raporlu: ...',
      error: (_, _) => 'Kadro Bilgileri Alınamadı',
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF1E3740),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Color(0xFF4DD0E1),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Personeller',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Personel Yönetim Ekranı',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            metricsText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
