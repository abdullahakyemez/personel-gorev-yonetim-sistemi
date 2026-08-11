import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import '../presentation/widgets/leave_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_list.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/forms/leave_form.dart';

class LeavePage extends ConsumerWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(filteredLeaveProvider);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: PageHeader(
                title: 'İzinler',
                subtitle: 'Personel İzin Yönetim Ekranı',
              ),
            ),

            IconButton(
              tooltip: 'Filtreleri Temizle',

              onPressed: () {
                ref.read(leaveSearchProvider.notifier).state = '';

                ref.read(selectedLeaveTypeProvider.notifier).state = null;

                ref.read(selectedLeavePersonnelProvider.notifier).state = null;

                ref.read(leaveStartDateFilterProvider.notifier).state = null;

                ref.read(leaveEndDateFilterProvider.notifier).state = null;
              },

              icon: const Icon(Icons.filter_alt_off),
            ),
            SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const Dialog(
                    child: SizedBox(width: 700, child: LeaveForm()),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Yeni İzin'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const LeaveFilterBar(),

        const SizedBox(height: 24),

        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: leaves.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          'Kayıtlı izin bulunmuyor.',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return LeaveList(leaves: list);
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      'İzinler yüklenemedi.\n$error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const VerticalDivider(width: 1),

              const Expanded(flex: 3, child: LeaveDetailPanel()),
            ],
          ),
        ),
      ],
    );
  }
}
