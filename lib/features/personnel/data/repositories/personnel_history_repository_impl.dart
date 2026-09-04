import 'package:drift/drift.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_history_repository.dart';

class PersonnelHistoryRepositoryImpl implements PersonnelHistoryRepository {
  final AppDatabase database;

  PersonnelHistoryRepositoryImpl(this.database);

  @override
  Future<List<PersonnelHistory>> getByPersonnel(String personnelId) async {
    final rows = await (database.select(database.personnelHistoryTable)
          ..where((table) => table.personnelId.equals(personnelId))
          ..orderBy([
            (table) => OrderingTerm.desc(table.createdAt),
          ]))
        .get();

    return rows
        .map(
          (row) => PersonnelHistory(
            id: row.id,
            personnelId: row.personnelId,
            action: PersonnelHistoryAction.values.firstWhere(
              (action) => action.name == row.action,
              orElse: () => PersonnelHistoryAction.personnelUpdated,
            ),
            description: row.description,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> add({
    required String personnelId,
    required PersonnelHistoryAction action,
    required String description,
    DateTime? createdAt,
  }) async {
    await database.into(database.personnelHistoryTable).insert(
          PersonnelHistoryTableCompanion.insert(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            personnelId: personnelId,
            action: action.name,
            description: description,
            createdAt: createdAt == null
                ? const Value.absent()
                : Value(createdAt),
          ),
        );
  }

  @override
  Future<void> deleteByPersonnel(String personnelId) async {
    await (database.delete(database.personnelHistoryTable)
          ..where((table) => table.personnelId.equals(personnelId)))
        .go();
  }
}
