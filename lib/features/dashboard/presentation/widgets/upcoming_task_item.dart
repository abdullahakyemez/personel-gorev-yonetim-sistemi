import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/view_models/dashboard_upcoming_task.dart';

class UpcomingTaskItem extends StatelessWidget {
  final DashboardUpcomingTask task;

  const UpcomingTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(
      task.endDate.year,
      task.endDate.month,
      task.endDate.day,
    );

    final difference = end.difference(today).inDays;

    String subtitle;

    Color color;

    IconData icon;

    if (difference < 0) {
      subtitle = "${difference.abs()} gün gecikti";
      color = Colors.red;
      icon = Icons.error_outline;
    } else if (difference == 0) {
      subtitle = "Bugün bitiyor";
      color = Colors.orange;
      icon = Icons.warning_amber_rounded;
    } else {
      subtitle = "$difference gün kaldı";
      color = Colors.green;
      icon = Icons.schedule;
    }

    return ListTile(
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.personnelName),

          Text(
            subtitle,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(DateFormatter.short(task.endDate)),
        ],
      ),
    );
  }
}
