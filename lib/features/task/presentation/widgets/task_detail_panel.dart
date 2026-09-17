import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';

import 'task_detail_info_row.dart';
import 'task_status_chip.dart';
import '../forms/task_form.dart';

class TaskDetailPanel extends ConsumerWidget {
  const TaskDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(selectedTaskProvider);
    final canEditTask = ref.watch(hasPermissionProvider(AppPermission.editTask));
    final canDeleteTask = ref.watch(hasPermissionProvider(AppPermission.deleteTask));

    if (task == null) {
      return const Center(
        child: Text('Görev seçiniz', style: TextStyle(fontSize: 16)),
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
        final assignedPersonnel = personnelList
            .where(
              (personnel) =>
                  personnel.id != null && task.personnelIds.contains(personnel.id),
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------
              // BAŞLIK
              // ----------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Detayı kapat',
                    onPressed: () {
                      ref.read(selectedTaskIdProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Görev Detayı',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------------
              // DURUM
              // ----------------------------------------------------------
              TaskDetailInfoRow(
                title: 'Durum',
                value: TaskStatusChip(status: task.status),
              ),

              // ----------------------------------------------------------
              // PERSONEL
              // ----------------------------------------------------------
              TaskDetailInfoRow(
                title: 'Personel',
                value: assignedPersonnel.isEmpty
                    ? Text(
                        'Personel atanmamış',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: assignedPersonnel.map((person) {
                          return ActionChip(
                            avatar: const Icon(Icons.person_outline, size: 16),
                            label: Text(person.fullName),
                            tooltip: '${person.fullName} profiline git',
                            onPressed: () {
                              if (person.id != null) {
                                ref.read(selectedPersonnelIdProvider.notifier).state =
                                    person.id;
                                context.go('/personeller');
                              }
                            },
                          );
                        }).toList(),
                      ),
              ),

              // ----------------------------------------------------------
              // BAŞLANGIÇ
              // ----------------------------------------------------------
              TaskDetailInfoRow(
                title: 'Başlangıç',
                value: Text(DateFormatter.short(task.startDate)),
              ),

              // ----------------------------------------------------------
              // BİTİŞ
              // ----------------------------------------------------------
              TaskDetailInfoRow(
                title: 'Bitiş',
                value: Text(DateFormatter.short(task.endDate)),
              ),

              const Divider(height: 40),

              // ----------------------------------------------------------
              // AÇIKLAMA
              // ----------------------------------------------------------
              Text('Açıklama', style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              if (canEditTask || canDeleteTask) ...[
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canEditTask)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: SizedBox(
                                  width: 700,
                                  child: TaskForm(task: task),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Düzenle'),
                      ),

                    if (canEditTask && canDeleteTask) const SizedBox(width: 12),

                    if (canDeleteTask)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onError,
                        ),
                        onPressed: () async {
                          if (task.id == null) {
                            return;
                          }

                          final assignedCount = task.personnelIds.length;
                          final details = <String>[];
                          if (assignedCount > 0) {
                            details.add(
                                '$assignedCount personele ait görev ataması kaldırılacaktır');
                          }

                          final confirmed = await showPGYSConfirmDialog(
                            context: context,
                            title: 'Görevi Sil',
                            message:
                                '"${task.title}" başlıklı görevi silmek istediğinize emin misiniz?',
                            details: details.isNotEmpty ? details : null,
                            confirmText: 'Sil',
                            cancelText: 'Vazgeç',
                            isDestructive: true,
                          );

                          if (confirmed != true) {
                            return;
                          }

                          await ref
                              .read(taskControllerProvider.notifier)
                              .deleteTask(task.id!);

                          ref.read(selectedTaskIdProvider.notifier).state = null;

                          if (context.mounted) {
                            PGYSFeedback.showSuccess(
                              context,
                              '"${task.title}" görevi başarıyla silindi.',
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
