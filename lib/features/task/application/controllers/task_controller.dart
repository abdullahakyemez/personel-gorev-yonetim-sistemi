import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

class TaskController extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    return ref.read(taskRepositoryProvider).getAll();
  }

  Future<void> refreshTasks() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).getAll(),
    );
  }

  Future<void> addTask(Task task) async {
    await ref.read(taskRepositoryProvider).add(task);
    await refreshTasks();
  }

  Future<void> updateTask(Task task) async {
    await ref.read(taskRepositoryProvider).update(task);
    await refreshTasks();
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).delete(id);
    await refreshTasks();
  }
}
