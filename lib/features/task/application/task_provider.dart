import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/data/repositories/task_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<Task>>(TaskController.new);

final taskSearchProvider = StateProvider<String>((ref) => '');
final selectedTaskStatusProvider = StateProvider<TaskStatus?>((ref) => null);
final selectedTaskPriorityProvider = StateProvider<TaskPriority?>(
  (ref) => null,
);

final selectedPersonnelProvider = StateProvider<String?>((ref) => null);

final filteredTaskProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskControllerProvider);
  final personnelAsync = ref.watch(personnelListProvider);

  final search = ref.watch(taskSearchProvider).toLowerCase();
  final status = ref.watch(selectedTaskStatusProvider);
  final priority = ref.watch(selectedTaskPriorityProvider);
  final personnel = ref.watch(selectedPersonnelProvider);

  return tasksAsync.whenData((tasks) {
    final personnelList = personnelAsync.when(
      data: (list) => list,
      loading: () => <Personnel>[],
      error: (_, __) => <Personnel>[],
    );

    // Arama
    final personnelMap = {for (final p in personnelList) p.registryNumber: p};

    var result = List<Task>.from(tasks);

    if (search.isNotEmpty) {
      result = result.where((task) {
        final person = personnelMap[task.personnelId];

        final personName = person?.fullName.toLowerCase() ?? "";
        final registry = person?.registryNumber.toLowerCase() ?? "";
        final title = task.title.toLowerCase();
        final description = task.description.toLowerCase();

        return title.contains(search) ||
            description.contains(search) ||
            personName.contains(search) ||
            registry.contains(search);
      }).toList();
    }

    // Durum filtresi
    if (status != null) {
      result = result.where((task) => task.status == status).toList();
    }

    // Öncelik filtresi
    if (priority != null) {
      result = result.where((task) => task.priority == priority).toList();
    }

    // Personel filtresi
    if (personnel != null) {
      result = result.where((task) => task.personnelId == personnel).toList();
    }

    return result;
  });
});
