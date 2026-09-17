import '../models/leave.dart';

class LeaveOverlap {
  const LeaveOverlap._();

  static bool rangesOverlap(
    DateTime firstStart,
    DateTime firstEnd,
    DateTime secondStart,
    DateTime secondEnd,
  ) {
    final aStart = _dateOnly(firstStart);
    final aEnd = _dateOnly(firstEnd);
    final bStart = _dateOnly(secondStart);
    final bEnd = _dateOnly(secondEnd);

    return !aEnd.isBefore(bStart) && !bEnd.isBefore(aStart);
  }

  static Leave? findConflict({
    required List<Leave> leaves,
    required int personnelId,
    required DateTime startDate,
    required DateTime endDate,
    String? excludeId,
  }) {
    for (final leave in leaves) {
      if (leave.personnelId != personnelId) continue;
      if (excludeId != null && leave.id == excludeId) continue;
      if (rangesOverlap(leave.startDate, leave.endDate, startDate, endDate)) {
        return leave;
      }
    }
    return null;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
