import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import '../../personnel/application/personnel_provider.dart';
import '../../personnel/domain/models/personnel.dart';
import '../../personnel/domain/services/personnel_status_resolver.dart';
import '../../leave/application/leave_provider.dart';
import '../../leave/domain/models/leave.dart';
import '../domain/models/report_statistics.dart';
import '../../task/application/task_provider.dart';
import '../../task/domain/models/task_status.dart';
import '../../task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';

final reportStartDateProvider = StateProvider<DateTime?>((ref) => currentWorkYear.start);

final reportEndDateProvider = StateProvider<DateTime?>((ref) => currentWorkYear.end);

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

final personnelReportStatisticsProvider =
    Provider<AsyncValue<PersonnelReportStatistics>>((ref) {
      final personnelAsync = ref.watch(scopedPersonnelProvider);
      final leaveAsync = ref.watch(scopedLeaveProvider);

      if (personnelAsync.isLoading || leaveAsync.isLoading) {
        return const AsyncLoading();
      }

      if (personnelAsync.hasError) {
        return AsyncError(personnelAsync.error!, personnelAsync.stackTrace!);
      }

      if (leaveAsync.hasError) {
        return AsyncError(leaveAsync.error!, leaveAsync.stackTrace!);
      }

      final personnel = personnelAsync.value!;
      final leaves = leaveAsync.value!;

      final now = DateTime.now();

      final statusList = personnel.map(
        (person) => PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: leaves,
          date: now,
        ),
      );

      final statuses = statusList.toList();

      final workScheduleDistribution = <String, int>{};
      final departmentDistribution = <String, int>{};
      final branchDistribution = <String, int>{};
      final rankDistribution = <String, int>{};

      for (final person in personnel) {
        // ------------------------------------------------------------
        // ÇALIŞMA DÜZENİ
        // ------------------------------------------------------------

        final scheduleLabel = person.workSchedule?.label ?? 'Belirtilmemiş';

        workScheduleDistribution[scheduleLabel] =
            (workScheduleDistribution[scheduleLabel] ?? 0) + 1;

        // ------------------------------------------------------------
        // ŞUBE
        // ------------------------------------------------------------

        departmentDistribution[person.department] =
            (departmentDistribution[person.department] ?? 0) + 1;

        // ------------------------------------------------------------
        // BÜRO
        // ------------------------------------------------------------

        branchDistribution[person.branch] =
            (branchDistribution[person.branch] ?? 0) + 1;

        // ------------------------------------------------------------
        // RÜTBE
        // ------------------------------------------------------------

        rankDistribution[person.rank] =
            (rankDistribution[person.rank] ?? 0) + 1;
      }

      return AsyncData(
        PersonnelReportStatistics(
          totalPersonnel: personnel.length,

          dutyPersonnel: statuses
              .where((status) => status == PersonnelStatus.duty)
              .length,

          restingPersonnel: statuses
              .where((status) => status == PersonnelStatus.resting)
              .length,

          leavePersonnel: statuses
              .where((status) => status == PersonnelStatus.leave)
              .length,

          sickReportPersonnel: statuses
              .where((status) => status == PersonnelStatus.sickReport)
              .length,

          workScheduleDistribution: workScheduleDistribution,
          departmentDistribution: departmentDistribution,
          branchDistribution: branchDistribution,
          rankDistribution: rankDistribution,
        ),
      );
    });

final leaveReportStatisticsProvider =
    Provider<AsyncValue<LeaveReportStatistics>>((ref) {
      final leaveAsync = ref.watch(scopedLeaveProvider);
      final personnelAsync = ref.watch(scopedPersonnelProvider);

      final filterStart = ref.watch(reportStartDateProvider);
      final filterEnd = ref.watch(reportEndDateProvider);

      if (leaveAsync.isLoading) {
        return const AsyncLoading();
      }

      if (leaveAsync.hasError) {
        return AsyncError(leaveAsync.error!, leaveAsync.stackTrace!);
      }

      final leaves = leaveAsync.value ?? <Leave>[];

      final startDate = filterStart == null ? null : _dateOnly(filterStart);

      final endDate = filterEnd == null ? null : _dateOnly(filterEnd);

      // ------------------------------------------------------------
      // TARİH ARALIĞIYLA KESİŞEN İZİNLER
      // ------------------------------------------------------------

      final filteredLeaves = leaves.where((leave) {
        final leaveStart = _dateOnly(leave.startDate);
        final leaveEnd = _dateOnly(leave.endDate);

        if (startDate != null && leaveEnd.isBefore(startDate)) {
          return false;
        }

        if (endDate != null && leaveStart.isAfter(endDate)) {
          return false;
        }

        return true;
      }).toList();

      // ------------------------------------------------------------
      // RAPOR İSTATİSTİKLERİ
      // ------------------------------------------------------------

      var totalLeaveCount = 0;
      var totalLeaveDays = 0;

      var annualLeaveCount = 0;
      var excuseLeaveCount = 0;
      var reportCount = 0;

      var annualLeaveDays = 0;
      var excuseLeaveDays = 0;
      var reportDays = 0;

      final personnelList = personnelAsync.value ?? <Personnel>[];
      final regMap = {
        for (final p in personnelList)
          if (p.id != null) p.id!: p.registryNumber,
      };

      final personnelLeaveCounts = <String, int>{};

      for (final leave in filteredLeaves) {
        final leaveStart = _dateOnly(leave.startDate);
        final leaveEnd = _dateOnly(leave.endDate);

        var effectiveStart = leaveStart;
        var effectiveEnd = leaveEnd;

        if (startDate != null && effectiveStart.isBefore(startDate)) {
          effectiveStart = startDate;
        }

        if (endDate != null && effectiveEnd.isAfter(endDate)) {
          effectiveEnd = endDate;
        }

        if (effectiveEnd.isBefore(effectiveStart)) {
          continue;
        }

        final days = effectiveEnd.difference(effectiveStart).inDays + 1;

        totalLeaveCount++;
        totalLeaveDays += days;

        switch (leave.type) {
          case LeaveType.annual:
            annualLeaveCount++;
            annualLeaveDays += days;
            break;

          case LeaveType.excuse:
            excuseLeaveCount++;
            excuseLeaveDays += days;
            break;

          case LeaveType.report:
            reportCount++;
            reportDays += days;
            break;
        }

        final registryNumber =
            regMap[leave.personnelId] ?? leave.personnelId.toString();
        personnelLeaveCounts[registryNumber] =
            (personnelLeaveCounts[registryNumber] ?? 0) + 1;
      }

      return AsyncData(
        LeaveReportStatistics(
          totalLeaveCount: totalLeaveCount,
          totalLeaveDays: totalLeaveDays,
          annualLeaveCount: annualLeaveCount,
          excuseLeaveCount: excuseLeaveCount,
          reportCount: reportCount,
          annualLeaveDays: annualLeaveDays,
          excuseLeaveDays: excuseLeaveDays,
          reportDays: reportDays,
          personnelLeaveCounts: personnelLeaveCounts,
        ),
      );
    });

final taskReportStatisticsProvider = Provider<AsyncValue<TaskReportStatistics>>(
  (ref) {
    final taskAsync = ref.watch(scopedTaskProvider);

    final filterStart = ref.watch(reportStartDateProvider);
    final filterEnd = ref.watch(reportEndDateProvider);

    if (taskAsync.isLoading) {
      return const AsyncLoading();
    }

    if (taskAsync.hasError) {
      return AsyncError(taskAsync.error!, taskAsync.stackTrace!);
    }

    final tasks = taskAsync.value ?? <Task>[];

    final startDate = filterStart == null ? null : _dateOnly(filterStart);
    final endDate = filterEnd == null ? null : _dateOnly(filterEnd);

    // ------------------------------------------------------------
    // TARİH FİLTRESİ
    // ------------------------------------------------------------
    //
    // Görevin başlangıç ve bitiş tarihi rapor aralığıyla
    // kesişiyorsa görev rapora dahil edilir.
    //
    // Örnek:
    // Görev       : 01.08 - 10.08
    // Rapor       : 05.08 - 07.08
    // Sonuç       : Dahil edilir.
    //
    final filteredTasks = tasks.where((task) {
      final taskStart = _dateOnly(task.startDate);
      final taskEnd = _dateOnly(task.endDate);

      if (startDate != null && taskEnd.isBefore(startDate)) {
        return false;
      }

      if (endDate != null && taskStart.isAfter(endDate)) {
        return false;
      }

      return true;
    }).toList();

    // ------------------------------------------------------------
    // GÖREV DURUMLARI
    // ------------------------------------------------------------

    final totalTasks = filteredTasks.length;
    final completedTasks = filteredTasks.where((task) => task.status == TaskStatus.completed).length;
    final inProgressTasks = filteredTasks.where((task) => task.status == TaskStatus.inProgress).length;
    final categoryCounts = <String, int>{for (final category in TaskCategory.values) category.label: 0};
    for (final task in filteredTasks) {
      final category = task.category;
      if (category != null) {
        categoryCounts[category.label] = categoryCounts[category.label]! + 1;
      }
    }

    return AsyncData(
      TaskReportStatistics(
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        inProgressTasks: inProgressTasks,
        categoryCounts: categoryCounts,
      ),
    );
  },
);
