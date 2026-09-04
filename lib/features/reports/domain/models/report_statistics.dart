class PersonnelReportStatistics {
  final int totalPersonnel;
  final int dutyPersonnel;
  final int restingPersonnel;
  final int leavePersonnel;
  final int sickReportPersonnel;

  final Map<String, int> workScheduleDistribution;
  final Map<String, int> departmentDistribution;
  final Map<String, int> branchDistribution;
  final Map<String, int> rankDistribution;

  const PersonnelReportStatistics({
    required this.totalPersonnel,
    required this.dutyPersonnel,
    required this.restingPersonnel,
    required this.leavePersonnel,
    required this.sickReportPersonnel,
    required this.workScheduleDistribution,
    required this.departmentDistribution,
    required this.branchDistribution,
    required this.rankDistribution,
  });

  factory PersonnelReportStatistics.empty() {
    return const PersonnelReportStatistics(
      totalPersonnel: 0,
      dutyPersonnel: 0,
      restingPersonnel: 0,
      leavePersonnel: 0,
      sickReportPersonnel: 0,
      workScheduleDistribution: {},
      departmentDistribution: {},
      branchDistribution: {},
      rankDistribution: {},
    );
  }
}

class LeaveReportStatistics {
  final int totalLeaveCount;
  final int totalLeaveDays;

  final int annualLeaveCount;
  final int excuseLeaveCount;
  final int reportCount;

  final int annualLeaveDays;
  final int excuseLeaveDays;
  final int reportDays;

  final Map<String, int> personnelLeaveCounts;

  const LeaveReportStatistics({
    required this.totalLeaveCount,
    required this.totalLeaveDays,
    required this.annualLeaveCount,
    required this.excuseLeaveCount,
    required this.reportCount,
    required this.annualLeaveDays,
    required this.excuseLeaveDays,
    required this.reportDays,
    required this.personnelLeaveCounts,
  });

  factory LeaveReportStatistics.empty() {
    return const LeaveReportStatistics(
      totalLeaveCount: 0,
      totalLeaveDays: 0,
      annualLeaveCount: 0,
      excuseLeaveCount: 0,
      reportCount: 0,
      annualLeaveDays: 0,
      excuseLeaveDays: 0,
      reportDays: 0,
      personnelLeaveCounts: {},
    );
  }
}

class TaskReportStatistics {
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final Map<String, int> categoryCounts;

  const TaskReportStatistics({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.categoryCounts,
  });

  factory TaskReportStatistics.empty() {
    return const TaskReportStatistics(
      totalTasks: 0,
      completedTasks: 0,
      inProgressTasks: 0,
      categoryCounts: {},
    );
  }
}
