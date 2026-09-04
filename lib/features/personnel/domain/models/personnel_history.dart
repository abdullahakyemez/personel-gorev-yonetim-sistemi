enum PersonnelHistoryAction {
  personnelCreated,
  personnelUpdated,
  personnelDeleted,
  leaveAdded,
  leaveUpdated,
  leaveDeleted,
  taskAdded,
  taskUpdated,
  taskAssigned,
  taskUnassigned,
  taskDeleted,
}

class PersonnelHistory {
  final String id;
  final String personnelId;
  final PersonnelHistoryAction action;
  final String description;
  final DateTime createdAt;

  const PersonnelHistory({
    required this.id,
    required this.personnelId,
    required this.action,
    required this.description,
    required this.createdAt,
  });
}
