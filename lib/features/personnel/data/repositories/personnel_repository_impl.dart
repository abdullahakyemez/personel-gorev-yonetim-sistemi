import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_history_repository.dart';

import '../../domain/repositories/personnel_repository.dart';
import '../mapper/personnel_mapper.dart';

class PersonnelRepositoryImpl implements PersonnelRepository {
  final AppDatabase database;
  final PersonnelHistoryRepository historyRepository;

  PersonnelRepositoryImpl(this.database, this.historyRepository);

  @override
  Future<List<Personnel>> getAllPersonnel() async {
    final rows = await database.select(database.personnelTable).get();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> addPersonnel(Personnel personnel) async {
    await database.transaction(() async {
      await database
          .into(database.personnelTable)
          .insert(personnel.toInsertCompanion());

      await historyRepository.add(
        personnelId: personnel.registryNumber,
        action: PersonnelHistoryAction.personnelCreated,
        description: '${personnel.fullName} personel kaydı oluşturuldu.',
      );
    });
  }

  @override
  Future<void> deletePersonnel(int id) async {
    await database.transaction(() async {
      final row = await (database.select(
        database.personnelTable,
      )..where((table) => table.id.equals(id))).getSingleOrNull();

      if (row == null) return;

      await (database.delete(
        database.personnelTable,
      )..where((table) => table.id.equals(id))).go();

      await historyRepository.add(
        personnelId: row.registryNumber,
        action: PersonnelHistoryAction.personnelDeleted,
        description: '${row.fullName} personel kaydı silindi.',
      );
    });
  }

  @override
  Future<Personnel?> getPersonnelById(int id) async {
    final row = await (database.select(
      database.personnelTable,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    return row?.toDomain();
  }

  @override
  Future<void> updatePersonnel(Personnel personnel) async {
    if (personnel.id == null) {
      throw ArgumentError('Güncellenecek personelin id değeri olmalıdır.');
    }

    await database.transaction(() async {
      await (database.update(database.personnelTable)
            ..where((tbl) => tbl.id.equals(personnel.id!)))
          .write(personnel.toCompanion());

      await historyRepository.add(
        personnelId: personnel.registryNumber,
        action: PersonnelHistoryAction.personnelUpdated,
        description: '${personnel.fullName} personel bilgileri güncellendi.',
      );
    });
  }

  @override
  Future<void> deleteManyPersonnel(List<int> ids) async {
    await database.transaction(() async {
      for (final id in ids) {
        final row = await (database.select(
          database.personnelTable,
        )..where((table) => table.id.equals(id))).getSingleOrNull();

        if (row == null) continue;

        await (database.delete(
          database.personnelTable,
        )..where((table) => table.id.equals(id))).go();

        await historyRepository.add(
          personnelId: row.registryNumber,
          action: PersonnelHistoryAction.personnelDeleted,
          description: '${row.fullName} personel kaydı silindi.',
        );
      }
    });
  }
}
