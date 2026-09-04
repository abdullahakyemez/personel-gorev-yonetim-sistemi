class DashboardStatistics {
  final int totalPersonnel;
  final int activePersonnel;
  final int restingPersonnel;
  final int leavePersonnel;
  final int sickReportPersonnel;

  final int totalTasks;
  final int inProgressTasks;
  final int completedTasks;
  final int overdueTasks;
  final int todayEndingTasks;

  const DashboardStatistics({
    required this.totalPersonnel,
    required this.activePersonnel,
    required this.restingPersonnel,
    required this.leavePersonnel,
    required this.sickReportPersonnel,
    required this.totalTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.overdueTasks,
    required this.todayEndingTasks,
  });
}
