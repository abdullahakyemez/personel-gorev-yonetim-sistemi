import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/application/reports_provider.dart';
import '../domain/models/personnel_detail_report_statistics.dart';

final selectedReportPersonnelIdProvider = StateProvider<int?>((ref) => null);

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

bool _dateRangesOverlap({
  required DateTime itemStart,
  required DateTime itemEnd,
  DateTime? filterStart,
  DateTime? filterEnd,
}) {
  if (filterStart != null && itemEnd.isBefore(filterStart)) {
    return false;
  }

  if (filterEnd != null && itemStart.isAfter(filterEnd)) {
    return false;
  }

  return true;
}

int _calculateFilteredDayCount({
  required DateTime itemStart,
  required DateTime itemEnd,
  DateTime? filterStart,
  DateTime? filterEnd,
}) {
  var effectiveStart = itemStart;
  var effectiveEnd = itemEnd;

  if (filterStart != null && effectiveStart.isBefore(filterStart)) {
    effectiveStart = filterStart;
  }

  if (filterEnd != null && effectiveEnd.isAfter(filterEnd)) {
    effectiveEnd = filterEnd;
  }

  if (effectiveEnd.isBefore(effectiveStart)) {
    return 0;
  }

  return effectiveEnd.difference(effectiveStart).inDays + 1;
}

final personnelDetailReportProvider =
    Provider<AsyncValue<PersonnelDetailReportStatistics?>>((ref) {
      final personnelAsync = ref.watch(scopedPersonnelProvider);
      final leaveAsync = ref.watch(scopedLeaveProvider);
      final taskAsync = ref.watch(scopedTaskProvider);

      final selectedId = ref.watch(selectedReportPersonnelIdProvider);

      final filterStartValue = ref.watch(reportStartDateProvider);
      final filterEndValue = ref.watch(reportEndDateProvider);

      if (selectedId == null) {
        return const AsyncData(null);
      }

      if (personnelAsync.isLoading ||
          leaveAsync.isLoading ||
          taskAsync.isLoading) {
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

      final personnelList = personnelAsync.value!;
      final leaves = leaveAsync.value ?? <Leave>[];
      final tasks = taskAsync.value ?? [];

      Personnel? personnel;

      for (final person in personnelList) {
        if (person.id == selectedId) {
          personnel = person;
          break;
        }
      }

      if (personnel == null) {
        return const AsyncData(null);
      }

      final now = DateTime.now();

      final filterStart = filterStartValue == null
          ? null
          : _dateOnly(filterStartValue);

      final filterEnd = filterEndValue == null
          ? null
          : _dateOnly(filterEndValue);

      // ------------------------------------------------------------
      // PERSONELE AİT GÖREVLER
      // ------------------------------------------------------------

      final personnelTasks = tasks.where((task) {
        if (!task.personnelIds.contains(personnel!.id)) {
          return false;
        }

        final taskStart = _dateOnly(task.startDate);
        final taskEnd = _dateOnly(task.endDate);

        return _dateRangesOverlap(
          itemStart: taskStart,
          itemEnd: taskEnd,
          filterStart: filterStart,
          filterEnd: filterEnd,
        );
      }).toList();

      final totalTasks = personnelTasks.length;

      final completedTasks = personnelTasks
          .where((task) => task.status == TaskStatus.completed)
          .length;

      final inProgressTasks = personnelTasks
          .where((task) => task.status == TaskStatus.inProgress)
          .length;

      final categoryCounts = <String, int>{for (final category in TaskCategory.values) category.label: 0};
      for (final task in personnelTasks) {
        if (categoryCounts.containsKey(task.title)) {
          categoryCounts[task.title] = categoryCounts[task.title]! + 1;
        }
      }

      // ------------------------------------------------------------
      // PERSONELE AİT İZİN / RAPORLAR
      // ------------------------------------------------------------

      final personnelLeaves = leaves.where((leave) {
        if (leave.personnelId != personnel!.id) {
          return false;
        }

        final leaveStart = _dateOnly(leave.startDate);
        final leaveEnd = _dateOnly(leave.endDate);

        return _dateRangesOverlap(
          itemStart: leaveStart,
          itemEnd: leaveEnd,
          filterStart: filterStart,
          filterEnd: filterEnd,
        );
      }).toList();

      final leaveRecords = personnelLeaves.where((leave) {
        return leave.type == LeaveType.annual || leave.type == LeaveType.excuse;
      }).toList();

      final reportRecords = personnelLeaves.where((leave) {
        return leave.type == LeaveType.report;
      }).toList();

      // ------------------------------------------------------------
      // İZİN / RAPOR GÜN HESAPLAMALARI
      // ------------------------------------------------------------

      int calculateDays(Leave leave) {
        return _calculateFilteredDayCount(
          itemStart: _dateOnly(leave.startDate),
          itemEnd: _dateOnly(leave.endDate),
          filterStart: filterStart,
          filterEnd: filterEnd,
        );
      }

      final annualLeaveDays = personnelLeaves
          .where((leave) => leave.type == LeaveType.annual)
          .fold<int>(0, (total, leave) => total + calculateDays(leave));

      final excuseLeaveDays = personnelLeaves
          .where((leave) => leave.type == LeaveType.excuse)
          .fold<int>(0, (total, leave) => total + calculateDays(leave));

      final reportDays = reportRecords.fold<int>(
        0,
        (total, leave) => total + calculateDays(leave),
      );

      // ------------------------------------------------------------
      // GÜNCEL PERSONEL DURUMU
      // ------------------------------------------------------------

      final currentStatus = PersonnelStatusResolver.resolve(
        personnel: personnel,
        leaves: leaves,
        date: now,
      );

      return AsyncData(
        PersonnelDetailReportStatistics(
          personnel: personnel,
          tasks: personnelTasks,
          leaves: leaveRecords,
          reports: reportRecords,
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          inProgressTasks: inProgressTasks,
          categoryCounts: categoryCounts,
          annualLeaveDays: annualLeaveDays,
          excuseLeaveDays: excuseLeaveDays,
          reportDays: reportDays,
          currentStatus: currentStatus,
        ),
      );
    });
