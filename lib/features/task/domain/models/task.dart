import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class Task {
  final String? id;

  final String personnelId;

  final String title;

  final String description;

  final TaskPriority priority;

  final TaskStatus status;

  //final DateTime createdAt;

  final DateTime startDate;

  final DateTime endDate;

  const Task({
    this.id,
    required this.personnelId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    //required this.createdAt,
    required this.startDate,
    required this.endDate,
  });

  Task copyWith({
    String? id,
    String? personnelId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Task(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      //createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
