import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

class PersonnelDetailReportStatistics {
  final Personnel personnel;

  final List<Task> tasks;
  final List<Leave> leaves;
  final List<Leave> reports;

  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final Map<String, int> categoryCounts;

  final int annualLeaveDays;
  final int excuseLeaveDays;
  final int reportDays;

  final PersonnelStatus currentStatus;

  const PersonnelDetailReportStatistics({
    required this.personnel,
    required this.tasks,
    required this.leaves,
    required this.reports,
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.categoryCounts,
    required this.annualLeaveDays,
    required this.excuseLeaveDays,
    required this.reportDays,
    required this.currentStatus,
  });
}
