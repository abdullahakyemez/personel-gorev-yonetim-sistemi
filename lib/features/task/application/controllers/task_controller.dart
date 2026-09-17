import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';

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
    for (final personnelId in task.personnelIds) {
      ref.invalidate(personnelHistoryProvider(personnelId));
    }
  }

  Future<void> updateTask(Task task) async {
    final previousTask = state.value
        ?.where((t) => t.id == task.id)
        .firstOrNull;
    final affectedPersonnelIds = {
      ...?previousTask?.personnelIds,
      ...task.personnelIds,
    };

    await _repository.update(task);

    state = AsyncData(await _repository.getAll());
    for (final personnelId in affectedPersonnelIds) {
      ref.invalidate(personnelHistoryProvider(personnelId));
    }
  }

  Future<void> deleteTask(String id) async {
    final existingTask = state.value
        ?.where((t) => t.id == id)
        .firstOrNull;

    await _repository.delete(id);

    state = AsyncData(await _repository.getAll());
    if (existingTask != null) {
      for (final personnelId in existingTask.personnelIds) {
        ref.invalidate(personnelHistoryProvider(personnelId));
      }
    }
  }
}
