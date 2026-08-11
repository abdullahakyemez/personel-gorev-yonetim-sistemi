import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class DashboardRecentActivity {
  final String personnelName;
  final String taskTitle;
  final TaskStatus status;

  const DashboardRecentActivity({
    required this.personnelName,
    required this.taskTitle,
    required this.status,
  });
}
