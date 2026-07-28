import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';

import '../../domain/models/personnel.dart';
import '../../domain/repositories/personnel_repository.dart';
import '../mapper/personnel_mapper.dart';

class PersonnelRepositoryImpl implements PersonnelRepository {
  final AppDatabase database;

  PersonnelRepositoryImpl(this.database);

  @override
  Future<List<Personnel>> getAllPersonnel() async {
    // birazdan dolduracağız
    final rows = await database.select(database.personnelTable).get();

    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> addPersonnel(Personnel personnel) async {
    await database
        .into(database.personnelTable)
        .insert(personnel.toInsertCompanion());
  }

  @override
  Future<void> deletePersonnel(int id) async {
    final query = database.delete(database.personnelTable);
    query.where((tbl) => tbl.id.equals(id));
    await query.go();
  }

  @override
  Future<Personnel?> getPersonnelById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePersonnel(Personnel personnel) async {
    await (database.update(database.personnelTable)
          ..where((tbl) => tbl.id.equals(personnel.id!)))
        .write(personnel.toCompanion());
  }
}
