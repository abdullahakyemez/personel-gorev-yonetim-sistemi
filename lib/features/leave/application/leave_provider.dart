import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/repositories/leave_repository_impl.dart';
import '../domain/models/leave.dart';
import '../domain/repositories/leave_repository.dart';
import '../../personnel/application/personnel_provider.dart';

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImpl();
});

final leaveControllerProvider =
    AsyncNotifierProvider<LeaveController, List<Leave>>(LeaveController.new);

class LeaveController extends AsyncNotifier<List<Leave>> {
  @override
  Future<List<Leave>> build() async {
    return ref.read(leaveRepositoryProvider).getAll();
  }

  Future<void> refreshLeaves() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(leaveRepositoryProvider).getAll(),
    );
  }

  Future<void> addLeave(Leave leave) async {
    await ref.read(leaveRepositoryProvider).add(leave);
    await refreshLeaves();
  }

  Future<void> updateLeave(Leave leave) async {
    await ref.read(leaveRepositoryProvider).update(leave);
    await refreshLeaves();
  }

  Future<void> deleteLeave(String id) async {
    await ref.read(leaveRepositoryProvider).delete(id);
    await refreshLeaves();
  }
}

// ------------------------------------------------------------
// FİLTRELER
// ------------------------------------------------------------

final leaveSearchProvider = StateProvider<String>((ref) => '');

final selectedLeaveTypeProvider = StateProvider<LeaveType?>((ref) => null);

final selectedLeavePersonnelProvider = StateProvider<String?>((ref) => null);
final leaveStartDateFilterProvider = StateProvider<DateTime?>((ref) => null);

final leaveEndDateFilterProvider = StateProvider<DateTime?>((ref) => null);

// ------------------------------------------------------------
// FİLTRELENMİŞ İZİNLER
// ------------------------------------------------------------

final filteredLeaveProvider = Provider<AsyncValue<List<Leave>>>((ref) {
  final leavesAsync = ref.watch(leaveControllerProvider);
  final personnelAsync = ref.watch(personnelListProvider);

  final search = ref.watch(leaveSearchProvider).trim().toLowerCase();
  final leaveType = ref.watch(selectedLeaveTypeProvider);
  final personnelId = ref.watch(selectedLeavePersonnelProvider);

  final startDate = ref.watch(leaveStartDateFilterProvider);
  final endDate = ref.watch(leaveEndDateFilterProvider);

  return leavesAsync.whenData((leaves) {
    final personnelList = personnelAsync.when(
      data: (list) => list,
      loading: () => [],
      error: (_, _) => [],
    );

    final personnelMap = {
      for (final personnel in personnelList)
        personnel.registryNumber: personnel,
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
