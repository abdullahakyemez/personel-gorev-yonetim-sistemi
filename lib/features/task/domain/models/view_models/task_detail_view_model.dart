import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

class TaskDetailViewModel {
  final Task task;
  final String personnelName;

  const TaskDetailViewModel({required this.task, required this.personnelName});
}
