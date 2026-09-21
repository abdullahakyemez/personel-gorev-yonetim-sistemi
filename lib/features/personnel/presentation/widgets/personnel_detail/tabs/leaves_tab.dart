import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class LeavesTab extends ConsumerWidget {
  final Personnel person;

  const LeavesTab({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(leaveControllerProvider);

    return leavesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('İzinler yüklenemedi: $error'),
      ),
      data: (allLeaves) {
        final leaves = allLeaves
            .where((leave) => leave.personnelId == person.id)
            .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));

        if (leaves.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: Center(
              child: Text('Bu personele ait izin kaydı bulunmuyor.'),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leaves.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final leave = leaves[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              leading: const Icon(Icons.event_available_outlined),
              title: Text(leave.type.label),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  '${DateFormatter.short(leave.startDate)} - '
                  '${DateFormatter.short(leave.endDate)}'
                  '\n${leave.description}',
                ),
              ),
              trailing: Text(
                '${leave.dayCount} gün',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          },
        );
      },
    );
  }
}
