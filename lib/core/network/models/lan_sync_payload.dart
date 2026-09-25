class LanSyncPayload {
  final DateTime timestamp;
  final int schemaVersion;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> personnel;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> taskPersonnel;
  final List<Map<String, dynamic>> leave;
  final List<Map<String, dynamic>> personnelHistory;
  final List<Map<String, dynamic>> settings;

  const LanSyncPayload({
    required this.timestamp,
    this.schemaVersion = 11,
    this.users = const [],
    this.personnel = const [],
    this.tasks = const [],
    this.taskPersonnel = const [],
    this.leave = const [],
    this.personnelHistory = const [],
    this.settings = const [],
  });

  int get totalRecordCount =>
      users.length +
      personnel.length +
      tasks.length +
      taskPersonnel.length +
      leave.length +
      personnelHistory.length +
      settings.length;

  bool get isEmpty => totalRecordCount == 0;

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'schemaVersion': schemaVersion,
      'users': users,
      'personnel': personnel,
      'tasks': tasks,
      'taskPersonnel': taskPersonnel,
      'leave': leave,
      'personnelHistory': personnelHistory,
      'settings': settings,
    };
  }

  factory LanSyncPayload.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> parseList(dynamic raw) {
      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }
      return const [];
    }

    return LanSyncPayload(
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      schemaVersion: json['schemaVersion'] as int? ?? 11,
      users: parseList(json['users']),
      personnel: parseList(json['personnel']),
      tasks: parseList(json['tasks']),
      taskPersonnel: parseList(json['taskPersonnel']),
      leave: parseList(json['leave']),
      personnelHistory: parseList(json['personnelHistory']),
      settings: parseList(json['settings']),
    );
  }
}
