import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/database_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/data/repositories/task_repository_impl.dart';
import '../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  if (getIt.isRegistered<TaskRepository>()) {
    return getIt<TaskRepository>();
  }
  return TaskRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(personnelHistoryRepositoryProvider),
  );
});
