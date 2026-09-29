enum WorkScheduleType {
  twoPlusOne,
  onePlusOne,
  sixPlusOne,
  fivePlusTwo,
  custom,
}

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

    if (difference < 0 || cycleLength <= 0) {
      return false;
    }

    final cycleDay = difference % cycleLength;

    return cycleDay < dutyDays;
  }

  bool isRestDay(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    if (target.isBefore(start)) {
      return false;
    }

    return !isDutyDay(date);
  }

  /// 1+1 çalışma düzeninde olup olmadığını belirler.
  bool get isOnePlusOne =>
      type == WorkScheduleType.onePlusOne || (dutyDays == 1 && restDays == 1);

  /// Başka bir 1+1 çalışma düzeni ile aynı döngüye (aynı gün görev, aynı gün istirahat)
  /// sahip olup olmadığını kontrol eder.
  bool hasSameCycleAs(WorkSchedule other) {
    if (!isOnePlusOne || !other.isOnePlusOne) {
      return false;
    }

    final startA = DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final startB = DateTime.utc(
      other.startDate.year,
      other.startDate.month,
      other.startDate.day,
    );

    final diffInDays = startA.difference(startB).inDays.abs();
    return diffInDays % 2 == 0;
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
