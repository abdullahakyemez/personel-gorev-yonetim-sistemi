import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

extension TaskExtension on Task {
  int get remainingDays {
    final today = DateTime.now();

    final start = DateTime(today.year, today.month, today.day);

    final end = DateTime(endDate.year, endDate.month, endDate.day);

    return end.difference(start).inDays;
  }

  bool get isExpired => remainingDays < 0;

  bool get isToday => remainingDays == 0;
}
