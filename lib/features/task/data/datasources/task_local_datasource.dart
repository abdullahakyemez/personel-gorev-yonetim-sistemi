import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/datasource/seed/seed_personnel_data.dart';

class TaskLocalDatasource {
  static final List<Task> tasks = [
    Task(
      id: "1",
      personnelIds: [abdullah.registryNumber],
      title: "Devriye Görevi",
      description: "Çarşı ve mahalle devriyesi",
      status: TaskStatus.inProgress,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),

    Task(
      id: "2",
      personnelIds: [fazli.registryNumber],
      title: "Şüpheli Takibi",
      description: "Belirlenen şahsın fiziki takibi",
      status: TaskStatus.waiting,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),

    Task(
      id: "3",
      personnelIds: [yilmaz.registryNumber],
      title: "İfade Alma",
      description: "Mağdur ifadesi alınacak",
      status: TaskStatus.completed,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];
}
