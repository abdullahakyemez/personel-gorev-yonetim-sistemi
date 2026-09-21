import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/banners/pgys_module_banner.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/table/leave_table.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class LeavePage extends ConsumerWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(filteredLeaveProvider);
    final selectedLeave = ref.watch(selectedLeaveProvider);
    final hasSelection = selectedLeave != null;

    final countText = leaves.when(
      data: (list) => '${list.length} Kayıt',
      loading: () => '...',
      error: (_, _) => '0 Kayıt',
    );

    return Column(
      children: [
        PGYSModuleBanner(
          title: 'İzin ve Sağlık Raporları',
          subtitle: 'Personel İzin, Mazeret ve Rapor Takip Ekranı',
          icon: Icons.beach_access_outlined,
          statusText: countText,
        ),
        const SizedBox(height: 12),
        const LeaveFilterBar(),
        const SizedBox(height: 12),
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
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(128),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Kayıtlı izin bulunmuyor.',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, AppSpacing.md, AppSpacing.sm),
                      child: Text(
                        '${list.length} izin bulundu',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Expanded(child: LeaveTable(leaves: list)),
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
