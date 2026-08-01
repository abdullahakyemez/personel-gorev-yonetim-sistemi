import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/data/repositories/task_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<Task>>(TaskController.new);
