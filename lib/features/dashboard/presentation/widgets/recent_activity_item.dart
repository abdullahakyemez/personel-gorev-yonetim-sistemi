import 'package:flutter/material.dart';
import '../../domain/models/recent_activity.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class RecentActivityItem extends StatelessWidget {
  final RecentActivity activity;

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
        activity.personName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 2),
        child: Text(
          activity.action,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      trailing: Text(
        activity.time,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
