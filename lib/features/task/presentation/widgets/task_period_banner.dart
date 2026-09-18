import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/banners/pgys_module_banner.dart';

class TaskPeriodBanner extends StatelessWidget {
  final int totalCount;
  final int completedCount;

  const TaskPeriodBanner({
    super.key,
    required this.totalCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSModuleBanner(
      title: 'ÇALIŞMA YILI DÖNEMİ',
      subtitle:
          '1 Eylül ${currentWorkYear.start.year} - 31 Ağustos ${currentWorkYear.end.year} Görev Planı',
      icon: Icons.calendar_month_outlined,
      statusText: 'Toplam Görev: $totalCount | Tamamlanan: $completedCount',
    );
  }
}
