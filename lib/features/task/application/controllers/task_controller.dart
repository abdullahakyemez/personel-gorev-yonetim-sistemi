import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../task_repository_provider.dart';

class TaskController extends AsyncNotifier<List<Task>> {
  TaskRepository get _repository {
    return ref.read(taskRepositoryProvider);
  }

  @override
  Future<List<Task>> build() async {
    return _repository.getAll();
  }

  Future<void> addTask(Task task) async {
    await _repository.add(task);

    state = AsyncData(await _repository.getAll());
  }

  Future<void> updateTask(Task task) async {
    await _repository.update(task);

    state = AsyncData(await _repository.getAll());
  }

  Future<void> deleteTask(String id) async {
    await _repository.delete(id);

    state = AsyncData(await _repository.getAll());
  }
}
