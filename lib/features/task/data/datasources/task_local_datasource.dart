import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/datasource/seed/seed_personnel_data.dart';

class TaskLocalDatasource {
  static final List<Task> tasks = [
    Task(
      id: "1",
      personnelId: abdullah.registryNumber,
      title: "Devriye Görevi",
      description: "Çarşı ve mahalle devriyesi",
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      //createdAt: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),

    Task(
      id: "2",
      personnelId: fazli.registryNumber,
      title: "Şüpheli Takibi",
      description: "Belirlenen şahsın fiziki takibi",
      priority: TaskPriority.critical,
      status: TaskStatus.waiting,
      //createdAt: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),

    Task(
      id: "3",
      personnelId: yilmaz.registryNumber,
      title: "İfade Alma",
      description: "Mağdur ifadesi alınacak",
      priority: TaskPriority.normal,
      status: TaskStatus.completed,
      //createdAt: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];
}
