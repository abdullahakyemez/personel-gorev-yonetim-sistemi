import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../personnel/domain/models/personnel.dart';
import '../../personnel/domain/models/work_schedule.dart';
import '../../task/domain/models/task.dart';
import '../../task/domain/models/task_status.dart';
import '../../leave/domain/models/leave.dart';
import '../domain/models/app_user.dart';
import '../domain/services/permission_engine.dart';
import 'auth_state_provider.dart';

/// Scoping filter helper based on active user
class DataScopeFilter {
  final AppUser? currentUser;
  final Personnel? currentUserPersonnel;
  final Map<int, Personnel>? allPersonnelMap;

  const DataScopeFilter(
    this.currentUser, {
    this.currentUserPersonnel,
    this.allPersonnelMap,
  });

  DataScopeFilter withPersonnelContext({
    Personnel? currentUserPersonnel,
    Map<int, Personnel>? allPersonnelMap,
  }) {
    return DataScopeFilter(
      currentUser,
      currentUserPersonnel: currentUserPersonnel ?? this.currentUserPersonnel,
      allPersonnelMap: allPersonnelMap ?? this.allPersonnelMap,
    );
  }

  WorkSchedule? _resolveChiefSchedule() {
    if (currentUser == null) return null;
    if (currentUserPersonnel?.workSchedule != null) {
      return currentUserPersonnel!.workSchedule;
    }
    if (allPersonnelMap != null && currentUser!.personnelId != null) {
      final p = allPersonnelMap![currentUser!.personnelId];
      if (p?.workSchedule != null) return p!.workSchedule;
    }
    if (allPersonnelMap != null && currentUser!.username.isNotEmpty) {
      for (final p in allPersonnelMap!.values) {
        if (p.registryNumber.trim().toLowerCase() ==
            currentUser!.username.trim().toLowerCase()) {
          if (p.workSchedule != null) return p.workSchedule;
        }
      }
    }
    // Fallback: Kullanıcıya grup atanmışsa gruptaki 1+1 personelin döngüsünü referans al
    if (allPersonnelMap != null &&
        currentUser!.groupName != null &&
        currentUser!.groupName!.trim().isNotEmpty) {
      final targetGroup = currentUser!.groupName!.trim().toLowerCase();
      for (final p in allPersonnelMap!.values) {
        final pGroup =
            (p.department.isNotEmpty ? p.department : p.branch).trim().toLowerCase();
        if (pGroup == targetGroup &&
            p.workSchedule != null &&
            p.workSchedule!.isOnePlusOne) {
          return p.workSchedule;
        }
      }
    }
    return null;
  }

  bool filterPersonnel(Personnel person, {bool? isDutyToday}) {
    if (currentUser == null) return true;
    final isDuty = isDutyToday ?? (person.status == PersonnelStatus.duty);
    final group =
        person.department.isNotEmpty ? person.department : person.branch;
    final chiefSchedule = _resolveChiefSchedule();

    return PermissionEngine.canViewPersonnel(
      currentUser!,
      targetPersonnelId: person.id ?? -1,
      isTargetDutyToday: isDuty,
      targetGroup: group,
      targetSchedule: person.workSchedule,
      chiefSchedule: chiefSchedule,
    );
  }

  bool filterTask(Task task, Map<int, Personnel> personnelMap) {
    if (currentUser == null) return true;
    final now = DateTime.now();
    final isTaskActiveToday = ((now.isAfter(task.startDate) ||
                _isSameDay(now, task.startDate)) &&
            (now.isBefore(task.endDate) || _isSameDay(now, task.endDate))) ||
        task.status == TaskStatus.inProgress;

    final groupMap = {
      for (final entry in personnelMap.entries)
        entry.key: entry.value.department.isNotEmpty
            ? entry.value.department
            : entry.value.branch,
    };

    final allowedPersonnelIds = {
      for (final entry in personnelMap.entries)
        if (filterPersonnel(entry.value)) entry.key,
    };

    return PermissionEngine.canViewTask(
      currentUser!,
      task.personnelIds,
      personnelGroupMap: groupMap,
      isTaskActiveToday: isTaskActiveToday,
      allowedPersonnelIds: allowedPersonnelIds,
    );
  }

  bool filterLeave(Leave leave, Map<int, Personnel> personnelMap) {
    if (currentUser == null) return true;
    final now = DateTime.now();
    final isLeaveActiveToday = (now.isAfter(leave.startDate) ||
            _isSameDay(now, leave.startDate)) &&
        (now.isBefore(leave.endDate) || _isSameDay(now, leave.endDate));

    final targetPerson = personnelMap[leave.personnelId];
    final targetGroup = targetPerson != null
        ? (targetPerson.department.isNotEmpty
            ? targetPerson.department
            : targetPerson.branch)
        : null;

    final isTargetPersonnelAllowed =
        targetPerson != null ? filterPersonnel(targetPerson) : false;

    return PermissionEngine.canViewLeave(
      currentUser!,
      targetPersonnelId: leave.personnelId,
      targetGroup: targetGroup,
      isLeaveActiveToday: isLeaveActiveToday,
      isTargetPersonnelAllowed: isTargetPersonnelAllowed,
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final dataScopeFilterProvider = Provider<DataScopeFilter>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return DataScopeFilter(currentUser);
});
