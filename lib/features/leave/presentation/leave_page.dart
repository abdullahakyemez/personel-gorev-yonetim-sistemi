import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/forms/leave_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_list.dart';

class LeavePage extends ConsumerStatefulWidget {
  const LeavePage({super.key});

  @override
  ConsumerState<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends ConsumerState<LeavePage> {
  Future<void> _showLeaveForm() async {
    await showDialog(
      context: context,
      builder: (_) => const Dialog(
        child: SizedBox(width: 700, child: LeaveForm()),
      ),
    );
  }

  void _clearFilters() {
    ref.read(leaveSearchProvider.notifier).state = '';
    ref.read(selectedLeaveTypeProvider.notifier).state = null;
    ref.read(selectedLeavePersonnelProvider.notifier).state = null;
    ref.read(leaveStartDateFilterProvider.notifier).state = null;
    ref.read(leaveEndDateFilterProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final leaves = ref.watch(filteredLeaveProvider);
    final selectedLeave = ref.watch(selectedLeaveProvider);
    final hasSelection = selectedLeave != null;
    final canCreateLeave = ref.watch(hasPermissionProvider(AppPermission.createLeave));

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
              onPressed: _clearFilters,
              icon: const Icon(Icons.filter_alt_off),
            ),
            if (canCreateLeave) ...[
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _showLeaveForm,
                icon: const Icon(Icons.add),
                label: const Text('Yeni İzin'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const LeaveFilterBar(),
        const SizedBox(height: 24),
        Expanded(
          child: leaves.when(
            data: (list) {
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kayıtlı izin bulunmuyor.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                );
              }

              return MasterDetailLayout(
                detailVisible: hasSelection,
                onBack: () =>
                    ref.read(selectedLeaveIdProvider.notifier).state = null,
                master: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        '${list.length} izin bulundu',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(child: LeaveList(leaves: list)),
                  ],
                ),
                detail: const LeaveDetailPanel(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'İzinler yüklenemedi.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
