import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/repositories/leave_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_history_repository.dart';

import '../mapper/leave_mapper.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final AppDatabase database;
  final PersonnelHistoryRepository historyRepository;

  LeaveRepositoryImpl(this.database, this.historyRepository);

  @override
  Future<List<Leave>> getAll() async {
    final rows = await database.select(database.leaveTable).get();
    return rows.map(LeaveMapper.toDomain).toList();
  }

  @override
  Future<Leave?> getById(String id) async {
    final row = await (database.select(database.leaveTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (row == null) return null;
    return LeaveMapper.toDomain(row);
  }

  @override
  Future<List<Leave>> getByPersonnel(String personnelId) async {
    final rows = await (database.select(database.leaveTable)
          ..where((table) => table.personnelId.equals(personnelId)))
        .get();

    return rows.map(LeaveMapper.toDomain).toList();
  }

  @override
  Future<void> add(Leave leave) async {
    await database.transaction(() async {
      await database
          .into(database.leaveTable)
          .insert(LeaveMapper.toCompanion(leave));

      await historyRepository.add(
        personnelId: leave.personnelId,
        action: PersonnelHistoryAction.leaveAdded,
        description:
            'İzin kaydı eklendi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.type.name}).',
      );
    });
  }

  @override
  Future<void> update(Leave leave) async {
    await database.transaction(() async {
      await (database.update(database.leaveTable)
            ..where((table) => table.id.equals(leave.id)))
          .write(LeaveMapper.toCompanion(leave));

      await historyRepository.add(
        personnelId: leave.personnelId,
        action: PersonnelHistoryAction.leaveUpdated,
        description:
            'İzin kaydı güncellendi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.type.name}).',
      );
    });
  }

  @override
  Future<void> delete(String id) async {
    await database.transaction(() async {
      final leave = await getById(id);
      if (leave == null) return;

      await (database.delete(database.leaveTable)
            ..where((table) => table.id.equals(id)))
          .go();

      await historyRepository.add(
        personnelId: leave.personnelId,
        action: PersonnelHistoryAction.leaveDeleted,
        description:
            'İzin kaydı silindi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.type.name}).',
      );
    });
  }

  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';
  }
}
