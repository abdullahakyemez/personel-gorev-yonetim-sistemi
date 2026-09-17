enum LeaveType { annual, excuse, report }

class Leave {
  final String id;
  final int personnelId;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveType type;
  final String description;
  final String address;

  const Leave({
    required this.id,
    required this.personnelId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
    this.address = '',
  });

  int get dayCount {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return end.difference(start).inDays + 1;
  }

  Leave copyWith({
    String? id,
    int? personnelId,
    DateTime? startDate,
    DateTime? endDate,
    LeaveType? type,
    String? description,
    String? address,
  }) {
    return Leave(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      description: description ?? this.description,
      address: address ?? this.address,
    );
  }
}
