enum WorkScheduleType { twoPlusOne, onePlusOne, sixPlusOne, custom }

class WorkSchedule {
  final WorkScheduleType type;

  /// Kaç gün görev?
  final int dutyDays;

  /// Kaç gün istirahat?
  final int restDays;

  /// Döngünün başladığı gün.
  /// Bu tarih ilk görev günü kabul edilir.
  final DateTime startDate;

  const WorkSchedule({
    required this.type,
    required this.dutyDays,
    required this.restDays,
    required this.startDate,
  });

  int get cycleLength => dutyDays + restDays;

  String get label {
    return '$dutyDays+$restDays';
  }

  bool isDutyDay(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    final difference = target.difference(start).inDays;

    if (difference < 0) {
      return false;
    }

    final cycleDay = difference % cycleLength;

    return cycleDay < dutyDays;
  }

  bool isRestDay(DateTime date) {
    return !isDutyDay(date);
  }

  WorkSchedule copyWith({
    WorkScheduleType? type,
    int? dutyDays,
    int? restDays,
    DateTime? startDate,
  }) {
    return WorkSchedule(
      type: type ?? this.type,
      dutyDays: dutyDays ?? this.dutyDays,
      restDays: restDays ?? this.restDays,
      startDate: startDate ?? this.startDate,
    );
  }
}
