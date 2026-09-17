import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/repositories/leave_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';

import '../domain/models/leave.dart';

import 'package:personel_gorev_yonetim_sistemi/features/auth/application/data_scope_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import '../../personnel/application/personnel_provider.dart';
import '../application/leave_repository_provider.dart';
import '../domain/services/leave_entitlement_service.dart';

final leaveControllerProvider =
    AsyncNotifierProvider<LeaveController, List<Leave>>(LeaveController.new);

class LeaveController extends AsyncNotifier<List<Leave>> {
  LeaveRepository get _repository {
    return ref.read(leaveRepositoryProvider);
  }

  @override
  Future<List<Leave>> build() async {
    return _repository.getAll();
  }

  Future<void> refreshLeaves() async {
    state = AsyncData(await _repository.getAll());
  }

  Future<void> addLeave(Leave leave) async {
    await _repository.add(leave);

    state = AsyncData(await _repository.getAll());
    ref.invalidate(personnelHistoryProvider(leave.personnelId));
  }

  Future<void> updateLeave(Leave leave) async {
    final existingLeave = state.value
        ?.where((l) => l.id == leave.id)
        .firstOrNull;

    await _repository.update(leave);

    state = AsyncData(await _repository.getAll());
    ref.invalidate(personnelHistoryProvider(leave.personnelId));
    if (existingLeave != null && existingLeave.personnelId != leave.personnelId) {
      ref.invalidate(personnelHistoryProvider(existingLeave.personnelId));
    }
  }

  Future<void> deleteLeave(String id) async {
    final existingLeave = state.value
        ?.where((l) => l.id == id)
        .firstOrNull;

    await _repository.delete(id);

    state = AsyncData(await _repository.getAll());
    if (existingLeave != null) {
      ref.invalidate(personnelHistoryProvider(existingLeave.personnelId));
    }
  }
}
// ------------------------------------------------------------
// FİLTRELER
// ------------------------------------------------------------

final leaveSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final selectedLeaveTypeProvider = StateProvider.autoDispose<LeaveType?>((ref) => null);

final selectedLeavePersonnelProvider = StateProvider.autoDispose<int?>((ref) => null);
final leaveStartDateFilterProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final leaveEndDateFilterProvider = StateProvider.autoDispose<DateTime?>((ref) => null);


final leaveEntitlementServiceProvider = Provider<LeaveEntitlementService>((ref) {
  return const LeaveEntitlementService();
});

final personnelLeaveEntitlementProvider =
    Provider.family<LeaveEntitlement?, Personnel>((ref, personnel) {
  final leavesAsync = ref.watch(leaveControllerProvider);
  final service = ref.watch(leaveEntitlementServiceProvider);

  return leavesAsync.when(
    data: (leaves) => service.calculate(
      personnel: personnel,
      leaves: leaves,
    ),
    loading: () => null,
    error: (_, _) => null,
  );
});

// ------------------------------------------------------------
// KULLANICI ROL KAPSAMINA GÖRE İZİNLER
// ------------------------------------------------------------

final scopedLeaveProvider = Provider<AsyncValue<List<Leave>>>((ref) {
  final leavesAsync = ref.watch(leaveControllerProvider);
  final personnelAsync = ref.watch(personnelListProvider);
  final scopeFilter = ref.watch(dataScopeFilterProvider);

  return leavesAsync.whenData((leaves) {
    final personnelList = personnelAsync.when(
      data: (list) => list,
      loading: () => <Personnel>[],
      error: (_, _) => <Personnel>[],
    );

    final personnelMap = <int, Personnel>{
      for (final personnel in personnelList)
        if (personnel.id != null) personnel.id!: personnel,
    };

    return leaves
        .where((leave) => scopeFilter.filterLeave(leave, personnelMap))
        .toList();
  });
});

// ------------------------------------------------------------
// FİLTRELENMİŞ İZİNLER
// ------------------------------------------------------------

final filteredLeaveProvider = Provider<AsyncValue<List<Leave>>>((ref) {
  final scopedLeavesAsync = ref.watch(scopedLeaveProvider);
  final personnelAsync = ref.watch(personnelListProvider);

  final search = ref.watch(leaveSearchProvider).trim().toLowerCase();
  final leaveType = ref.watch(selectedLeaveTypeProvider);
  final personnelId = ref.watch(selectedLeavePersonnelProvider);

  final startDate = ref.watch(leaveStartDateFilterProvider);
  final endDate = ref.watch(leaveEndDateFilterProvider);

  return scopedLeavesAsync.whenData((leaves) {
    final personnelList = personnelAsync.when(
      data: (list) => list,
      loading: () => <Personnel>[],
      error: (_, _) => <Personnel>[],
    );

    final personnelMap = <int, Personnel>{
      for (final personnel in personnelList)
        if (personnel.id != null) personnel.id!: personnel,
    };

    var result = List<Leave>.from(leaves);

    // ------------------------------------------------------------
    // ARAMA
    // ------------------------------------------------------------

    if (search.isNotEmpty) {
      result = result.where((leave) {
        final personnel = personnelMap[leave.personnelId];

        final fullName = personnel?.fullName.toLowerCase() ?? '';

        final registry = personnel?.registryNumber.toLowerCase() ?? '';

        final description = leave.description.toLowerCase();

        return fullName.contains(search) ||
            registry.contains(search) ||
            description.contains(search);
      }).toList();
    }

    // ------------------------------------------------------------
    // İZİN TÜRÜ
    // ------------------------------------------------------------

    if (leaveType != null) {
      result = result.where((leave) => leave.type == leaveType).toList();
    }

    // ------------------------------------------------------------
    // PERSONEL
    // ------------------------------------------------------------

    if (personnelId != null) {
      result = result
          .where((leave) => leave.personnelId == personnelId)
          .toList();
    }

    // ------------------------------------------------------------
    // TARİH FİLTRESİ
    // ------------------------------------------------------------

    DateTime dateOnly(DateTime date) {
      return DateTime(date.year, date.month, date.day);
    }

    if (startDate != null) {
      final filterStart = dateOnly(startDate);

      result = result.where((leave) {
        final leaveEnd = dateOnly(leave.endDate);

        return !leaveEnd.isBefore(filterStart);
      }).toList();
    }

    if (endDate != null) {
      final filterEnd = dateOnly(endDate);

      result = result.where((leave) {
        final leaveStart = dateOnly(leave.startDate);

        return !leaveStart.isAfter(filterEnd);
      }).toList();
    }

    return result;
  });
});
