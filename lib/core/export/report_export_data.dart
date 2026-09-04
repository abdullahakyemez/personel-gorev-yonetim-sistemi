import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import '../../features/task/domain/models/task.dart';
import '../utils/work_year.dart';

class ReportExportData {
  final DateTime startDate;
  final DateTime endDate;
  final List<Personnel> personnel;
  final List<Leave> leaves;
  final List<Task> tasks;

  ReportExportData({
    required this.startDate,
    required this.endDate,
    required this.personnel,
    required this.leaves,
    required this.tasks,
  });

  List<WorkYearPeriod> get periods {
    if (endDate.isBefore(startDate)) return const [];

    final result = <WorkYearPeriod>[];
    var cursor = workYearForDate(startDate).start;

    while (!cursor.isAfter(endDate)) {
      final period = workYearForDate(cursor);
      if (!result.any((item) => item.start == period.start)) {
        result.add(period);
      }
      cursor = DateTime(period.end.year + 1, 9, 1);
    }

    return result;
  }

  bool overlaps(
    DateTime itemStart,
    DateTime itemEnd,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final start = DateTime(itemStart.year, itemStart.month, itemStart.day);
    final end = DateTime(itemEnd.year, itemEnd.month, itemEnd.day);
    return !end.isBefore(rangeStart) && !start.isAfter(rangeEnd);
  }

  int clippedDays(
    DateTime itemStart,
    DateTime itemEnd,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    var effectiveStart = itemStart;
    var effectiveEnd = itemEnd;

    if (effectiveStart.isBefore(rangeStart)) effectiveStart = rangeStart;
    if (effectiveEnd.isAfter(rangeEnd)) effectiveEnd = rangeEnd;
    if (effectiveEnd.isBefore(effectiveStart)) return 0;

    final start = DateTime(
      effectiveStart.year,
      effectiveStart.month,
      effectiveStart.day,
    );
    final end = DateTime(
      effectiveEnd.year,
      effectiveEnd.month,
      effectiveEnd.day,
    );
    return end.difference(start).inDays + 1;
  }
}
