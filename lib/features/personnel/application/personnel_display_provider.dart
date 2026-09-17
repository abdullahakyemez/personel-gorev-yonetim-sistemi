import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../leave/application/leave_provider.dart';
import '../domain/models/personnel.dart';
import '../domain/services/personnel_status_resolver.dart';
import 'personnel_provider.dart';

final selectedPersonnelStatusProvider = StateProvider<PersonnelStatus?>(
  (ref) => null,
);

final displayedPersonnelProvider = Provider<AsyncValue<List<Personnel>>>((ref) {
  final filtered = ref.watch(filteredPersonnelProvider);
  final statusFilter = ref.watch(selectedPersonnelStatusProvider);
  final leavesAsync = ref.watch(leaveControllerProvider);

  return filtered.whenData((list) {
    if (statusFilter == null) return list;

    final leaves = leavesAsync.value ?? const [];
    return list
        .where(
          (person) =>
              PersonnelStatusResolver.resolve(
                personnel: person,
                leaves: leaves,
              ) ==
              statusFilter,
        )
        .toList();
  });
});
