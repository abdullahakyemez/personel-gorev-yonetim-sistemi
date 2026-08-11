import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/data/repositories/task_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<Task>>(TaskController.new);

final taskSearchProvider = StateProvider<String>((ref) => '');

final selectedTaskStatusProvider = StateProvider<TaskStatus?>((ref) => null);

final selectedPersonnelProvider = StateProvider<String?>((ref) => null);

final filteredTaskProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskControllerProvider);
  final personnelAsync = ref.watch(personnelListProvider);

  final search = ref.watch(taskSearchProvider).toLowerCase();
  final status = ref.watch(selectedTaskStatusProvider);
  final personnel = ref.watch(selectedPersonnelProvider);

  return tasksAsync.whenData((tasks) {
    final personnelList = personnelAsync.when(
      data: (list) => list,
      loading: () => <Personnel>[],
      error: (_, _) => <Personnel>[],
    );

    final personnelMap = {for (final p in personnelList) p.registryNumber: p};

    List<Task> result = List<Task>.from(tasks);

    if (search.isNotEmpty) {
      result = result.where((task) {
        final assignedPersonnel = task.personnelIds
            .map((id) => personnelMap[id])
            .whereType<Personnel>()
            .toList();

        final personnelNames = assignedPersonnel
            .map((person) => person.fullName.toLowerCase())
            .join(' ');

        final registryNumbers = assignedPersonnel
            .map((person) => person.registryNumber.toLowerCase())
            .join(' ');

        final title = task.title.toLowerCase();
        final description = task.description.toLowerCase();

        return title.contains(search) ||
            description.contains(search) ||
            personnelNames.contains(search) ||
            registryNumbers.contains(search);
      }).toList();
    }

    if (status != null) {
      result = result.where((task) => task.status == status).toList();
    }

    if (personnel != null) {
      result = result
          .where((task) => task.personnelIds.contains(personnel))
          .toList();
    }

    return result;
  });
});
