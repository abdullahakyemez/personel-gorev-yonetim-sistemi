import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../personnel/domain/models/personnel.dart';

import '../../personnel/application/personnel_provider.dart';
import '../../personnel/domain/services/personnel_status_resolver.dart';

import '../../leave/application/leave_provider.dart';
import '../../task/application/task_provider.dart';
import '../../task/domain/models/task_status.dart';
import '../../../core/utils/work_year.dart';
import '../domain/models/dashboard_statistics.dart';

final dashboardStatisticsProvider = Provider<AsyncValue>((ref) {
  final personnelAsync = ref.watch(personnelListProvider);
  final leaveAsync = ref.watch(leaveControllerProvider);
  final taskAsync = ref.watch(taskControllerProvider);

  if (personnelAsync.isLoading || leaveAsync.isLoading || taskAsync.isLoading) {
    return const AsyncLoading();
  }

  if (personnelAsync.hasError) {
    return AsyncError(personnelAsync.error!, personnelAsync.stackTrace!);
  }

  if (leaveAsync.hasError) {
    return AsyncError(leaveAsync.error!, leaveAsync.stackTrace!);
  }

  if (taskAsync.hasError) {
    return AsyncError(taskAsync.error!, taskAsync.stackTrace!);
  }

  final personnel = personnelAsync.value!;
  final leaves = leaveAsync.value!;
  final tasks = taskAsync.value!.where((task) => currentWorkYear.overlaps(task.startDate, task.endDate)).toList();

  final now = DateTime.now();

  final statuses = personnel.map(
    (person) => PersonnelStatusResolver.resolve(
      personnel: person,
      leaves: leaves,
      date: now,
    ),
  );

  final statusList = statuses.toList();

  return AsyncData(
    DashboardStatistics(
      totalPersonnel: personnel.length,

      activePersonnel: statusList
          .where((status) => status == PersonnelStatus.duty)
          .length,

      restingPersonnel: statusList
          .where((status) => status == PersonnelStatus.resting)
          .length,

      leavePersonnel: statusList
          .where((status) => status == PersonnelStatus.leave)
          .length,

      sickReportPersonnel: statusList
          .where((status) => status == PersonnelStatus.sickReport)
          .length,

      totalTasks: tasks.length,


      inProgressTasks: tasks
          .where((t) => t.status == TaskStatus.inProgress)
          .length,

      completedTasks: tasks
          .where((t) => t.status == TaskStatus.completed)
          .length,

      overdueTasks: 0,

      todayEndingTasks: tasks.where((t) {
        return t.endDate.year == now.year &&
            t.endDate.month == now.month &&
            t.endDate.day == now.day;
      }).length,
    ),
  );
});
