import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import '../../domain/models/view_models/dashboard_recent_activity.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class RecentActivityItem extends StatelessWidget {
  final DashboardRecentActivity activity;

  const RecentActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(
        activity.personnelName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(activity.taskTitle),
      trailing: Text(
        activity.status.label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
