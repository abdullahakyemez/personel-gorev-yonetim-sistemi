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
      final insertedId = await database
          .into(database.personnelTable)
          .insert(personnel.toInsertCompanion());

      await historyRepository.add(
        personnelId: insertedId,
        action: PersonnelHistoryAction.personnelCreated,
        description: '${personnel.fullName} personel kaydı oluşturuldu.',
      );
    });
  }

  @override
  Future<void> deletePersonnel(int id) async {
    await database.transaction(() async {
      await (database.delete(
        database.personnelTable,
      )..where((table) => table.id.equals(id))).go();
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
      final existing = await (database.select(
        database.personnelTable,
      )..where((table) => table.id.equals(personnel.id!))).getSingleOrNull();

      await (database.update(database.personnelTable)
            ..where((tbl) => tbl.id.equals(personnel.id!)))
          .write(personnel.toCompanion());

      final changes = <String>[];
      if (existing != null) {
        if (existing.fullName != personnel.fullName) {
          changes.add('Ad Soyad: ${existing.fullName} -> ${personnel.fullName}');
        }
        if (existing.rank != personnel.rank) {
          changes.add('Rütbe: ${existing.rank} -> ${personnel.rank}');
        }
        if (existing.title != personnel.title) {
          changes.add('Unvan: ${existing.title} -> ${personnel.title}');
        }
        if (existing.branch != personnel.branch) {
          changes.add('Branş: ${existing.branch} -> ${personnel.branch}');
        }
        if (existing.department != personnel.department) {
          changes.add('Birim: ${existing.department} -> ${personnel.department}');
        }
        if (existing.phone != personnel.phone) {
          changes.add('Telefon güncellendi');
        }
        if (existing.email != personnel.email) {
          changes.add('E-posta güncellendi');
        }
        if (existing.address != personnel.address) {
          changes.add('Adres güncellendi');
        }
        if (existing.status != personnel.status.name) {
          changes.add('Durum güncellendi');
        }
        if (existing.workScheduleType != personnel.workSchedule?.type.name) {
          changes.add('Çalışma düzeni güncellendi');
        }
      }

      final description = changes.isNotEmpty
          ? '${personnel.fullName} güncellendi (${changes.join(', ')}).'
          : '${personnel.fullName} personel bilgileri güncellendi.';

      await historyRepository.add(
        personnelId: personnel.id!,
        action: PersonnelHistoryAction.personnelUpdated,
        description: description,
      );
    });
  }

  @override
  Future<void> deleteManyPersonnel(List<int> ids) async {
    if (ids.isEmpty) return;
    await database.transaction(() async {
      await (database.delete(
        database.personnelTable,
      )..where((table) => table.id.isIn(ids))).go();
    });
  }
}
