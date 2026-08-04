import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_priority_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';

class TaskDetailPanel extends ConsumerWidget {
  const TaskDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(selectedTaskProvider);
    if (task == null) {
      return const Center(child: Text("Görev seçiniz"));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 24),

          Text("Açıklama", style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(task.description),

          const SizedBox(height: 24),

          Text("Durum", style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(task.status.label),

          const SizedBox(height: 24),

          Text("Öncelik", style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(task.priority.label),
        ],
      ),
    );
  }
}
