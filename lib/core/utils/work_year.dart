class WorkYearPeriod {
  final DateTime start;
  final DateTime end;

  const WorkYearPeriod({required this.start, required this.end});

  String get label =>
      '${start.day.toString().padLeft(2, '0')}.${start.month.toString().padLeft(2, '0')}.${start.year} - '
      '${end.day.toString().padLeft(2, '0')}.${end.month.toString().padLeft(2, '0')}.${end.year}';

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  bool overlaps(DateTime itemStart, DateTime itemEnd) {
    final s = DateTime(itemStart.year, itemStart.month, itemStart.day);
    final e = DateTime(itemEnd.year, itemEnd.month, itemEnd.day);
    return !e.isBefore(start) && !s.isAfter(end);
  }
}

WorkYearPeriod workYearForDate(DateTime date) {
  final year = date.month >= 9 ? date.year : date.year - 1;
  return WorkYearPeriod(
    start: DateTime(year, 9, 1),
    end: DateTime(year + 1, 8, 31),
  );
}

WorkYearPeriod get currentWorkYear => workYearForDate(DateTime.now());
