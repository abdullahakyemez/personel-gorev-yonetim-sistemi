import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../forms/leave_form.dart';
import '../../application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';

class LeaveDetailPanel extends ConsumerWidget {
  const LeaveDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leave = ref.watch(selectedLeaveProvider);
    final canEditLeave = ref.watch(hasPermissionProvider(AppPermission.editLeave));
    final canDeleteLeave = ref.watch(hasPermissionProvider(AppPermission.deleteLeave));

    if (leave == null) {
      return const Center(
        child: Text('İzin seçiniz', style: TextStyle(fontSize: 16)),
      );
    }

    final personnelAsync = ref.watch(personnelListProvider);

    return personnelAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => Center(
        child: Text(
          'Personel bilgileri yüklenemedi.\n$error',
          textAlign: TextAlign.center,
        ),
      ),

      data: (personnelList) {
        final personnel = personnelList
            .where((person) => person.id == leave.personnelId)
            .firstOrNull;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      leave.type.label,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Detayı kapat',
                    onPressed: () {
                      ref.read(selectedLeaveIdProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'İzin Detayı',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              _DetailRow(
                title: 'Personel',
                valueWidget: personnel == null
                    ? Text(
                        'Personel bulunamadı',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: ActionChip(
                          avatar: const Icon(Icons.person_outline, size: 16),
                          label: Text(personnel.fullName),
                          tooltip: '${personnel.fullName} profiline git',
                          onPressed: () {
                            if (personnel.id != null) {
                              ref.read(selectedPersonnelIdProvider.notifier).state =
                                  personnel.id;
                              context.go('/personeller');
                            }
                          },
                        ),
                      ),
              ),

              _DetailRow(title: 'İzin Türü', value: leave.type.label),

              _DetailRow(
                title: 'Başlangıç',
                value: DateFormatter.short(leave.startDate),
              ),

              _DetailRow(
                title: 'Bitiş',
                value: DateFormatter.short(leave.endDate),
              ),

              _DetailRow(title: 'Süre', value: '${leave.dayCount} gün'),

              const Divider(height: 40),

              Text('Açıklama', style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(
                leave.description.trim().isEmpty
                    ? 'Açıklama bulunmuyor.'
                    : leave.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              if (canEditLeave || canDeleteLeave) ...[
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canEditLeave)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: SizedBox(
                                  width: 700,
                                  child: LeaveForm(leave: leave),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Düzenle'),
                      ),

                    if (canEditLeave && canDeleteLeave) const SizedBox(width: 12),

                    if (canDeleteLeave)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onError,
                        ),
                        onPressed: () async {
                          final personName = personnel?.fullName ?? 'Personel';
                          final details = [
                            '${leave.dayCount} günlük izin / rapor kaydı silinecektir',
                            'Personelin aktif çalışma/nöbet durumu ve izin istatistikleri güncellenecektir',
                          ];

                          final confirmed = await showPGYSConfirmDialog(
                            context: context,
                            title: 'İzin Kaydını Sil',
                            message:
                                '$personName personeline ait ${leave.type.label} kaydını silmek istediğinize emin misiniz?',
                            details: details,
                            confirmText: 'Sil',
                            cancelText: 'Vazgeç',
                            isDestructive: true,
                          );

                          if (confirmed != true) {
                            return;
                          }

                          await ref
                              .read(leaveControllerProvider.notifier)
                              .deleteLeave(leave.id);

                          ref.read(selectedLeaveIdProvider.notifier).state = null;
                          ref.invalidate(personnelListProvider);

                          if (context.mounted) {
                            PGYSFeedback.showSuccess(
                              context,
                              '$personName personeline ait ${leave.type.label} kaydı silindi.',
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Sil'),
                      ),
                  ],
                ),
              ] else ...[
                const Spacer(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? valueWidget;

  const _DetailRow({required this.title, this.value, this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: valueWidget ??
                Text(value ?? '', style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
