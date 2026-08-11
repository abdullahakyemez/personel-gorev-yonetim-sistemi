class TaskAssignmentInfo {
  final int totalTasks;
  final int activeTasks;
  final int overdueTasks;

  const TaskAssignmentInfo({
    required this.totalTasks,
    required this.activeTasks,
    required this.overdueTasks,
  });

  bool get hasOverdue => overdueTasks > 0;

  bool get isOverloaded => activeTasks >= 5;
}
