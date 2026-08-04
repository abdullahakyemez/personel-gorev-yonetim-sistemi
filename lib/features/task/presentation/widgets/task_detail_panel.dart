import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'task_priority_chip.dart';
import 'task_status_chip.dart';
import 'task_detail_info_row.dart';
import '../forms/task_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';

class TaskDetailPanel extends ConsumerWidget {
  const TaskDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(selectedTaskProvider);

    if (task == null) {
      return const Center(child: Text("Görev seçiniz"));
    }
    final personnelAsync = ref.watch(personnelListProvider);
    String assignedPersonnel = "-";
    personnelAsync.whenData((list) {
      try {
        assignedPersonnel = list
            .firstWhere((p) => p.registryNumber == task.personnelId)
            .fullName;
      } catch (_) {}
    });

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 24),

          TaskDetailInfoRow(
            title: "Durum",
            value: TaskStatusChip(status: task.status),
          ),

          TaskDetailInfoRow(
            title: "Öncelik",
            value: TaskPriorityChip(priority: task.priority),
          ),
          TaskDetailInfoRow(
            title: "Personel",
            value: Text(
              assignedPersonnel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TaskDetailInfoRow(
            title: "Başlangıç",
            value: Text(DateFormatter.short(task.startDate)),
          ),

          TaskDetailInfoRow(
            title: "Bitiş",
            value: Text(DateFormatter.short(task.endDate)),
          ),
          const Divider(height: 40),
          Text("Açıklama", style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(task.description),

          const Spacer(),

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
                label: const Text("Düzenle"),
              ),

              const SizedBox(width: 12),

              FilledButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Görev Sil"),
                      content: Text(
                        "${task.title} görevini silmek istediğinize emin misiniz?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Vazgeç"),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Sil"),
                        ),
                      ],
                    ),
                  );
                  if (result == true) {
                    await ref
                        .read(taskControllerProvider.notifier)
                        .deleteTask(task.id!);
                    ref.read(selectedTaskIdProvider.notifier).state = null;
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text("Sil"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
