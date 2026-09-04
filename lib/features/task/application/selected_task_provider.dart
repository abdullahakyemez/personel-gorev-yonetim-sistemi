import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

import 'task_provider.dart';

final selectedTaskIdProvider = StateProvider.autoDispose<String?>((ref) => null);

final selectedTaskProvider = Provider.autoDispose<Task?>((ref) {
  final selectedId = ref.watch(selectedTaskIdProvider);

  final tasksAsync = ref.watch(taskControllerProvider);

  return tasksAsync.when(
    data: (tasks) {
      if (selectedId == null) return null;

      try {
        return tasks.firstWhere((e) => e.id == selectedId);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, _) => null,
  );
});
