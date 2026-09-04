import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import '../data/repositories/personnel_history_repository_impl.dart';
import '../domain/models/personnel_history.dart';
import '../domain/repositories/personnel_history_repository.dart';

final personnelHistoryRepositoryProvider = Provider<PersonnelHistoryRepository>(
  (ref) => PersonnelHistoryRepositoryImpl(getIt()),
);

final personnelHistoryProvider =
    FutureProvider.autoDispose.family<List<PersonnelHistory>, String>(
  (ref, personnelId) {
    final repository = ref.watch(personnelHistoryRepositoryProvider);
    return repository.getByPersonnel(personnelId);
  },
);
