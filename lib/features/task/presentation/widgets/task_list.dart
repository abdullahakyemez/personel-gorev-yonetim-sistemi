import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_card.dart';

class TaskList extends ConsumerWidget {
  final List<Task> tasks;

  //final String? selectedTaskId;

  final ValueChanged<Task>? onSelected;

  const TaskList({
    super.key,
    required this.tasks,
    //this.selectedTaskId,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedTaskIdProvider);

    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 48),
            SizedBox(height: 12),
            Text('Görev bulunamadı', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Arama veya filtre kriterlerinizi değiştirmeyi deneyin.'),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),

      itemCount: tasks.length,

      separatorBuilder: (_, _) => const SizedBox(height: 12),

      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskCard(
          task: task,
          selected: task.id == selectedId,
          onTap: () {
            ref.read(selectedTaskIdProvider.notifier).state = task.id;
            onSelected?.call(task);
          },
        );
      },
    );
  }
}
