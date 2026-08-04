import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_list.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskControllerProvider);

    return Column(
      children: [
        const PageHeader(title: "Görevler", subtitle: "Görev Yönetim Ekranı"),

        const SizedBox(height: 16),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: tasks.when(
                  data: (list) {
                    return TaskList(tasks: list);
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text(e.toString()),
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
