import 'package:get_it/get_it.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/repositories/personnel_history_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_history_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/add_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/delete_many_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/delete_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/get_all_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/update_personnel_usecase.dart';

import '../database/app_database.dart';
import '../../features/leave/data/repositories/leave_repository_impl.dart';
import '../../features/leave/domain/repositories/leave_repository.dart';
import '../../features/personnel/data/repositories/personnel_repository_impl.dart';
import '../../features/personnel/domain/repositories/personnel_repository.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import '../../features/task/domain/repositories/task_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<PersonnelHistoryRepository>(
    () => PersonnelHistoryRepositoryImpl(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<PersonnelRepository>(
    () => PersonnelRepositoryImpl(
      getIt<AppDatabase>(),
      getIt<PersonnelHistoryRepository>(),
    ),
  );

  getIt.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(
      getIt<AppDatabase>(),
      getIt<PersonnelHistoryRepository>(),
    ),
  );

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      getIt<AppDatabase>(),
      getIt<PersonnelHistoryRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AddPersonnelUseCase(getIt<PersonnelRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAllPersonnelUseCase(getIt<PersonnelRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdatePersonnelUseCase(getIt<PersonnelRepository>()),
  );
  getIt.registerLazySingleton(() => DeletePersonnelUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteManyPersonnelUseCase(getIt()));
}
