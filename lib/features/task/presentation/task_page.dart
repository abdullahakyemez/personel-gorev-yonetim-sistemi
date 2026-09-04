import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/forms/task_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_list.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  @override
  void dispose() {
    // Görev ekranına ait geçici seçimler sayfadan çıkınca temizlenir.
    ref.read(selectedTaskIdProvider.notifier).state = null;
    ref.read(taskSearchProvider.notifier).state = '';
    ref.read(selectedTaskStatusProvider.notifier).state = null;
    ref.read(selectedPersonnelProvider.notifier).state = null;
    ref.read(selectedTaskCategoryProvider.notifier).state = null;
    super.dispose();
  }

  Future<void> _showTaskForm() async {
    await showDialog(
      context: context,
      builder: (_) => const Dialog(
        child: SizedBox(width: 700, child: TaskForm()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(filteredTaskProvider);
    final selectedTaskId = ref.watch(selectedTaskIdProvider);
    final hasSelection = selectedTaskId != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PageHeader(
                title: 'Görevler',
                subtitle: 'Görev Yönetim Ekranı • Çalışma Yılı: ${currentWorkYear.label}',
              ),
            ),
            FilledButton.icon(
              onPressed: _showTaskForm,
              icon: const Icon(Icons.add),
              label: const Text('Yeni Görev'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const TaskFilterBar(),
        const SizedBox(height: 24),
        Expanded(
          child: tasks.when(
            data: (list) => Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: hasSelection ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          '${list.length} görev bulundu',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(child: TaskList(tasks: list)),
                    ],
                  ),
                ),
                if (hasSelection) ...[
                  const VerticalDivider(width: 1),
                  const Expanded(flex: 3, child: TaskDetailPanel()),
                ],
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text(e.toString())),
          ),
        ),
      ],
    );
  }
}
