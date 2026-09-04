import 'package:drift/drift.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

class LeaveMapper {
  static Leave toDomain(LeaveTableData data) {
    return Leave(
      id: data.id,
      personnelId: data.personnelId,
      startDate: data.startDate,
      endDate: data.endDate,
      type: LeaveType.values.firstWhere(
        (type) => type.name == data.type,
        orElse: () => LeaveType.excuse,
      ),
      description: data.description,
      address: data.address,
    );
  }

  static LeaveTableCompanion toCompanion(Leave leave) {
    return LeaveTableCompanion.insert(
      id: leave.id,
      personnelId: leave.personnelId,
      startDate: leave.startDate,
      endDate: leave.endDate,
      type: leave.type.name,
      description: leave.description,
      address: Value(leave.address),
    );
  }
}
