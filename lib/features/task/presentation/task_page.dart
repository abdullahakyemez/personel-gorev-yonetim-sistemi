import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_list.dart';
import 'widgets/task_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/forms/task_form.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTaskProvider);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: PageHeader(
                title: "Görevler",
                subtitle: "Görev Yönetim Ekranı",
              ),
            ),

            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const Dialog(
                    child: SizedBox(width: 700, child: TaskForm()),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Yeni Görev"),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const TaskFilterBar(),

        const SizedBox(height: 24),

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
