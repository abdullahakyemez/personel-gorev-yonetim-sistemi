import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> getAll();

  Future<Task?> getById(String id);

  Future<List<Task>> getByPersonnel(int personnelId);

  Future<void> add(Task task);

  Future<void> update(Task task);

  Future<void> delete(String id);

  Future<void> importInitialData(List<Task> tasks);
}
