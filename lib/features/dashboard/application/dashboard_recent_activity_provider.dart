import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/view_models/dashboard_recent_activity.dart';

import '../../personnel/application/personnel_provider.dart';
import '../../task/application/task_provider.dart';

final dashboardRecentActivityProvider =
    Provider<AsyncValue<List<DashboardRecentActivity>>>((ref) {
      final personnelAsync = ref.watch(scopedPersonnelProvider);
      final taskAsync = ref.watch(scopedTaskProvider);

      if (personnelAsync.isLoading || taskAsync.isLoading) {
        return const AsyncLoading();
      }

      if (personnelAsync.hasError) {
        return AsyncError(personnelAsync.error!, personnelAsync.stackTrace!);
      }

      if (taskAsync.hasError) {
        return AsyncError(taskAsync.error!, taskAsync.stackTrace!);
      }

      final personnel = personnelAsync.value!;
      final tasks = taskAsync.value!;

      final personnelMap = {
        for (final p in personnel)
          if (p.id != null) p.id!: p.fullName,
      };

      final activities = tasks.reversed.take(5).map((task) {
        final personnelNames = task.personnelIds
            .map((id) => personnelMap[id])
            .whereType<String>()
            .toList();

        return DashboardRecentActivity(
          personnelName: personnelNames.isEmpty
              ? '-'
              : personnelNames.join(', '),
          taskTitle: task.title,
          status: task.status,
        );
      }).toList();

      return AsyncData(activities);
    });
