enum LeaveType { annual, excuse, report }

class Leave {
  final String id;
  final String personnelId;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveType type;
  final String description;

  const Leave({
    required this.id,
    required this.personnelId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
  });

  int get dayCount {
    return endDate.difference(startDate).inDays + 1;
  }

  Leave copyWith({
    String? id,
    String? personnelId,
    DateTime? startDate,
    DateTime? endDate,
    LeaveType? type,
    String? description,
  }) {
    return Leave(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}
