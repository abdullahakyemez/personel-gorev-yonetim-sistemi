import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_sync_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';

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
  Future<List<Leave>> getByPersonnel(int personnelId) async {
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
            '${leave.type.label} eklendi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.dayCount} gün).',
      );
    });
    LanSyncService.notifyDataChanged('leave_add');
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
            '${leave.type.label} güncellendi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.dayCount} gün).',
      );
    });
    LanSyncService.notifyDataChanged('leave_update');
  }

  @override
  Future<void> delete(String id) async {
    await database.transaction(() async {
      final leave = await getById(id);
      if (leave == null) return;

      await (database.delete(database.leaveTable)
            ..where((table) => table.id.equals(id)))
          .go();

      await database.customStatement(
        'INSERT OR REPLACE INTO sync_deletions_table (id, table_name, record_id, deleted_at) VALUES (?, ?, ?, ?);',
        ['leave_$id', 'leave_table', id, DateTime.now().millisecondsSinceEpoch],
      );

      await historyRepository.add(
        personnelId: leave.personnelId,
        action: PersonnelHistoryAction.leaveDeleted,
        description:
            '${leave.type.label} silindi: ${_date(leave.startDate)} - ${_date(leave.endDate)} (${leave.dayCount} gün).',
      );
    });
    LanSyncService.notifyDataChanged('leave_delete');
  }


  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';
  }
}
