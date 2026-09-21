import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/table/task_table.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_period_banner.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTaskProvider);
    final allTasks = ref.watch(taskControllerProvider).value ?? [];
    final selectedTaskId = ref.watch(selectedTaskIdProvider);
    final hasSelection = selectedTaskId != null;

    final totalCount = allTasks.length;
    final completedCount =
        allTasks.where((t) => t.status == TaskStatus.completed).length;

    return Column(
      children: [
        TaskPeriodBanner(
          totalCount: totalCount,
          completedCount: completedCount,
        ),
        const SizedBox(height: 12),
        const TaskFilterBar(),
        const SizedBox(height: 12),
        Expanded(
          child: tasks.when(
            data: (list) {
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(128),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Kayıtlı görev bulunmuyor.',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                    ],
                  ),
                );
              }

              return MasterDetailLayout(
                detailVisible: hasSelection,
                onBack: () =>
                    ref.read(selectedTaskIdProvider.notifier).state = null,
                master: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xs,
                        0,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: Text(
                        '${list.length} görev bulundu',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Expanded(child: TaskTable(tasks: list)),
                  ],
                ),
                detail: const TaskDetailPanel(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text(e.toString())),
          ),
        ),
      ],
    );
  }
}
