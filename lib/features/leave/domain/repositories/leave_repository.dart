import '../models/leave.dart';

abstract interface class LeaveRepository {
  Future<List<Leave>> getAll();

  Future<Leave?> getById(String id);

  Future<List<Leave>> getByPersonnel(String personnelId);

  Future<void> add(Leave leave);

  Future<void> update(Leave leave);

  Future<void> delete(String id);
}
