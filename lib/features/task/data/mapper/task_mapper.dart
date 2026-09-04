import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

class TaskMapper {
  static Task toDomain({
    required TaskTableData task,
    required List<TaskPersonnelTableData> assignments,
  }) {
    return Task(
      id: task.id,
      personnelIds: assignments.map((item) => item.personnelId).toList(),
      title: task.title,
      description: task.description,
      status: Task.statusForDates(task.startDate, task.endDate),
      startDate: task.startDate,
      endDate: task.endDate,
    );
  }

  static TaskTableCompanion toTaskCompanion(Task task) {
    return TaskTableCompanion.insert(
      id: task.id!,
      title: task.title,
      description: task.description,
      status: task.status.name,
      startDate: task.startDate,
      endDate: task.endDate,
    );
  }

  static TaskPersonnelTableCompanion toPersonnelCompanion({
    required String taskId,
    required String personnelId,
  }) {
    return TaskPersonnelTableCompanion.insert(
      taskId: taskId,
      personnelId: personnelId,
    );
  }
}
