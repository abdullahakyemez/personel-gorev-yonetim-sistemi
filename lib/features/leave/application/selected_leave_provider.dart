import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/models/leave.dart';
import 'leave_provider.dart';

final selectedLeaveIdProvider = StateProvider<String?>((ref) => null);

final selectedLeaveProvider = Provider<Leave?>((ref) {
  final selectedId = ref.watch(selectedLeaveIdProvider);
  final leavesAsync = ref.watch(leaveControllerProvider);

  if (selectedId == null || !leavesAsync.hasValue) {
    return null;
  }

  final leaves = leavesAsync.value!;

  try {
    return leaves.firstWhere((leave) => leave.id == selectedId);
  } catch (_) {
    return null;
  }
});
