import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/database_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/data/repositories/leave_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import '../domain/repositories/leave_repository.dart';

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  if (getIt.isRegistered<LeaveRepository>()) {
    return getIt<LeaveRepository>();
  }
  return LeaveRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(personnelHistoryRepositoryProvider),
  );
});
