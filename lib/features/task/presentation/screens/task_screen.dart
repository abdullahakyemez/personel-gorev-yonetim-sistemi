import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_toolbar.dart';
import '../widgets/task_list.dart';
import '../widgets/task_detail_panel.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskControllerProvider);
    return Column(
      children: [
        const TaskToolbar(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: tasks.when(
                  data: (list) => TaskList(tasks: list),

                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),
              const VerticalDivider(width: 1),
              const Expanded(flex: 3, child: TaskDetailPanel()),
            ],
          ),
        ),
      ],
    );
  }
}
