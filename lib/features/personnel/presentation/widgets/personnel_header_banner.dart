import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/banners/pgys_module_banner.dart';
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

    return PGYSModuleBanner(
      title: 'Personeller',
      subtitle: 'Personel Yönetim Ekranı',
      icon: Icons.badge_outlined,
      statusText: metricsText,
    );
  }
}
