import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class TaskLocalDatasource {
  static final List<Task> tasks = [
    Task(
      id: "1",
      personnelId: "1",
      title: "Devriye Görevi",
      description: "Çarşı ve mahalle devriyesi",
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      createdAt: DateTime.now(),
      startDate: DateTime.now(),
    ),

    Task(
      id: "2",
      personnelId: "1",
      title: "Şüpheli Takibi",
      description: "Belirlenen şahsın fiziki takibi",
      priority: TaskPriority.critical,
      status: TaskStatus.waiting,
      createdAt: DateTime.now(),
    ),

    Task(
      id: "3",
      personnelId: "2",
      title: "İfade Alma",
      description: "Mağdur ifadesi alınacak",
      priority: TaskPriority.normal,
      status: TaskStatus.completed,
      createdAt: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];
}
