import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../personnel/domain/models/personnel.dart';
import '../../task/domain/models/task.dart';
import '../../task/domain/models/task_status.dart';
import '../../leave/domain/models/leave.dart';
import '../domain/models/app_user.dart';
import '../domain/services/permission_engine.dart';
import 'auth_state_provider.dart';

/// Scoping filter helper based on active user
class DataScopeFilter {
  final AppUser? currentUser;

  const DataScopeFilter(this.currentUser);

  bool filterPersonnel(Personnel person, {bool? isDutyToday}) {
    if (currentUser == null) return true;
    final isDuty = isDutyToday ?? (person.status == PersonnelStatus.duty);
    final group = person.department.isNotEmpty ? person.department : person.branch;
    return PermissionEngine.canViewPersonnel(
      currentUser!,
      targetPersonnelId: person.id ?? -1,
      isTargetDutyToday: isDuty,
      targetGroup: group,
    );
  }

  bool filterTask(Task task, Map<int, Personnel> personnelMap) {
    if (currentUser == null) return true;
    final now = DateTime.now();
    final isTaskActiveToday = ((now.isAfter(task.startDate) || _isSameDay(now, task.startDate)) &&
        (now.isBefore(task.endDate) || _isSameDay(now, task.endDate))) ||
        task.status == TaskStatus.inProgress;

    final groupMap = {
      for (final entry in personnelMap.entries)
        entry.key: entry.value.department.isNotEmpty ? entry.value.department : entry.value.branch,
    };

    return PermissionEngine.canViewTask(
      currentUser!,
      task.personnelIds,
      personnelGroupMap: groupMap,
      isTaskActiveToday: isTaskActiveToday,
    );
  }

  bool filterLeave(Leave leave, Map<int, Personnel> personnelMap) {
    if (currentUser == null) return true;
    final now = DateTime.now();
    final isLeaveActiveToday = (now.isAfter(leave.startDate) || _isSameDay(now, leave.startDate)) &&
        (now.isBefore(leave.endDate) || _isSameDay(now, leave.endDate));

    final targetPerson = personnelMap[leave.personnelId];
    final targetGroup = targetPerson != null
        ? (targetPerson.department.isNotEmpty ? targetPerson.department : targetPerson.branch)
        : null;

    return PermissionEngine.canViewLeave(
      currentUser!,
      targetPersonnelId: leave.personnelId,
      targetGroup: targetGroup,
      isLeaveActiveToday: isLeaveActiveToday,
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final dataScopeFilterProvider = Provider<DataScopeFilter>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return DataScopeFilter(currentUser);
});
