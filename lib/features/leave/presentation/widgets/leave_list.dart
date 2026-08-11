import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'leave_card.dart';

class LeaveList extends ConsumerWidget {
  final List<Leave> leaves;

  const LeaveList({super.key, required this.leaves});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedLeaveIdProvider);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: leaves.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final leave = leaves[index];

        return LeaveCard(
          leave: leave,
          selected: leave.id == selectedId,
          onTap: () {
            ref.read(selectedLeaveIdProvider.notifier).state = leave.id;
          },
        );
      },
    );
  }
}
