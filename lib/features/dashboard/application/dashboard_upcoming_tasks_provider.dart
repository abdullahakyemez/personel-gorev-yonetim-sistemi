import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../personnel/application/personnel_provider.dart';
import '../../task/application/task_provider.dart';
import '../domain/models/view_models/dashboard_upcoming_task.dart';

final upcomingTasksProvider = Provider<AsyncValue<List<DashboardUpcomingTask>>>(
  (ref) {
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

    final now = DateTime.now();

    final result = tasks
        .where(
          (t) => !t.endDate.isBefore(DateTime(now.year, now.month, now.day)),
        )
        .toList();

    result.sort((a, b) => a.endDate.compareTo(b.endDate));

    return AsyncData(
      result.take(5).map((task) {
        final personnelNames = task.personnelIds
            .map((id) => personnelMap[id])
            .whereType<String>()
            .toList();

        return DashboardUpcomingTask(
          title: task.title,
          personnelName: personnelNames.isEmpty
              ? '-'
              : personnelNames.join(', '),
          endDate: task.endDate,
        );
      }).toList(),
    );
  },
);
