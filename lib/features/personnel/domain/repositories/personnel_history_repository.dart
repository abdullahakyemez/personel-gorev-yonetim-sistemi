import '../models/personnel_history.dart';

abstract interface class PersonnelHistoryRepository {
  Future<List<PersonnelHistory>> getByPersonnel(int personnelId);

  Future<void> add({
    required int personnelId,
    required PersonnelHistoryAction action,
    required String description,
    DateTime? createdAt,
  });

  Future<void> deleteByPersonnel(int personnelId);
}
