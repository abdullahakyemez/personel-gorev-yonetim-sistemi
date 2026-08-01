import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAll() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task?> getById(String id) async {
    try {
      return _tasks.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Task>> getByPersonnel(String personnelId) async {
    return _tasks.where((e) => e.personnelId == personnelId).toList();
  }

  @override
  Future<void> add(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> update(Task task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> delete(String id) async {
    _tasks.removeWhere((e) => e.id == id);
  }
}
