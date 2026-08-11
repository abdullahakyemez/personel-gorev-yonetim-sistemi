import '../models/leave.dart';

extension LeaveTypeExtension on LeaveType {
  String get label {
    switch (this) {
      case LeaveType.annual:
        return "Yıllık İzin";

      case LeaveType.excuse:
        return "Mazeret İzni";

      case LeaveType.report:
        return "Rapor";
    }
  }
}
