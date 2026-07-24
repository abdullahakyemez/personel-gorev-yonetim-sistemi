import 'package:get_it/get_it.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/add_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/get_all_personnel_usecase.dart';

import '../database/app_database.dart';
import '../../features/personnel/data/repositories/personnel_repository_impl.dart';
import '../../features/personnel/domain/repositories/personnel_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<PersonnelRepository>(
    () => PersonnelRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton(
    () => AddPersonnelUseCase(getIt<PersonnelRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAllPersonnelUseCase(getIt<PersonnelRepository>()),
  );
}
