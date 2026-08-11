import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class Task {
  final String? id;
  final List<String> personnelIds;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime startDate;
  final DateTime endDate;

  const Task({
    this.id,
    required this.personnelIds,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  Task copyWith({
    String? id,
    List<String>? personnelIds,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Task(
      id: id ?? this.id,
      personnelIds: personnelIds ?? this.personnelIds,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
