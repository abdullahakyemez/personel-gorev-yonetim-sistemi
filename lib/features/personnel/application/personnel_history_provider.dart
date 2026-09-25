import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/database_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import '../data/repositories/personnel_history_repository_impl.dart';
import '../domain/models/personnel_history.dart';
import '../domain/repositories/personnel_history_repository.dart';

final personnelHistoryRepositoryProvider = Provider<PersonnelHistoryRepository>(
  (ref) {
    if (getIt.isRegistered<PersonnelHistoryRepository>()) {
      return getIt<PersonnelHistoryRepository>();
    }
    return PersonnelHistoryRepositoryImpl(ref.watch(databaseProvider));
  },
);

final personnelHistoryProvider =
    FutureProvider.autoDispose.family<List<PersonnelHistory>, int>(
  (ref, personnelId) {
    final repository = ref.watch(personnelHistoryRepositoryProvider);
    return repository.getByPersonnel(personnelId);
  },
);
