import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';

class Task {
  final String? id;
  final List<String> personnelIds;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  const Task({
    this.id,
    required this.personnelIds,
    required this.title,
    required this.description,
    required TaskStatus status,
    required this.startDate,
    required this.endDate,
  });

  TaskCategory? get category => TaskCategory.values.cast<TaskCategory?>().firstWhere(
    (item) => item!.label == title,
    orElse: () => null,
  );

  TaskStatus get status => statusForDates(startDate, endDate);

  static TaskStatus statusForDates(DateTime startDate, DateTime endDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return day.isAfter(end) ? TaskStatus.completed : TaskStatus.inProgress;
  }

  TaskStatus get automaticStatus => statusForDates(startDate, endDate);

  Task copyWith({
    String? id,
    List<String>? personnelIds,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final nextStart = startDate ?? this.startDate;
    final nextEnd = endDate ?? this.endDate;
    return Task(
      id: id ?? this.id,
      personnelIds: personnelIds ?? this.personnelIds,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? statusForDates(nextStart, nextEnd),
      startDate: nextStart,
      endDate: nextEnd,
    );
  }
}
