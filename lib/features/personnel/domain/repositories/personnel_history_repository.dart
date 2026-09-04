import '../models/personnel_history.dart';

abstract interface class PersonnelHistoryRepository {
  Future<List<PersonnelHistory>> getByPersonnel(String personnelId);

  Future<void> add({
    required String personnelId,
    required PersonnelHistoryAction action,
    required String description,
    DateTime? createdAt,
  });

  Future<void> deleteByPersonnel(String personnelId);
}
