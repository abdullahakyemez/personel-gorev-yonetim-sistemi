import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
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
                  task.personnelIds.contains(personnel.registryNumber),
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
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall,
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
                value: Text(
                  assignedPersonnel.isEmpty
                      ? 'Personel bulunamadı'
                      : assignedPersonnel.map((p) => p.fullName).join(', '),
                  style: Theme.of(context).textTheme.bodyLarge,
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

              const Spacer(),

              // ----------------------------------------------------------
              // AKSİYONLAR
              // ----------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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

                  const SizedBox(width: 12),

                  FilledButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Görev Sil'),
                            content: Text(
                              '"${task.title}" görevini silmek istediğinize emin misiniz?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Vazgeç'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Sil'),
                              ),
                            ],
                          );
                        },
                      );

                      if (result != true) {
                        return;
                      }

                      if (task.id == null) {
                        return;
                      }

                      await ref
                          .read(taskControllerProvider.notifier)
                          .deleteTask(task.id!);

                      ref.read(selectedTaskIdProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Sil'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
