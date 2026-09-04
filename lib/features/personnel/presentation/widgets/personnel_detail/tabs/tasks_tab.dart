import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_status_chip.dart';

class TasksTab extends ConsumerWidget {
  final Personnel person;

  const TasksTab({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskControllerProvider);

    return tasksAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'Görevler yüklenemedi: $error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (allTasks) {
        final personnelTasks = allTasks
                .where((task) =>
                    task.personnelIds.contains(person.registryNumber) &&
                    currentWorkYear.overlaps(task.startDate, task.endDate))
                .toList()
              ..sort((a, b) => a.endDate.compareTo(b.endDate));

        final counts = <TaskCategory, int>{
          for (final category in TaskCategory.values) category: 0,
        };
        for (final task in personnelTasks) {
          final category = task.category;
          if (category != null) counts[category] = counts[category]! + 1;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _TaskSummaryCard(title: 'Toplam Görev', value: personnelTasks.length, icon: Icons.assignment_outlined),
                const SizedBox(height: AppSpacing.sm),
                for (final category in TaskCategory.values) ...[
                  _TaskSummaryCard(title: category.label, value: counts[category]!, icon: Icons.assignment_turned_in_outlined),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Personel Görevleri',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            if (personnelTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(
                  child: Text(
                    'Bu personele atanmış görev bulunmuyor.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: personnelTasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return _PersonnelTaskCard(task: personnelTasks[index]);
                },
              ),
          ],
        );
      },
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const _TaskSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PGYSCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonnelTaskCard extends StatelessWidget {
  final Task task;

  const _PersonnelTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TaskStatusChip(status: task.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              task.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                _DateLabel(
                  icon: Icons.calendar_today_outlined,
                  text: DateFormatter.short(task.startDate),
                ),
                _DateLabel(
                  icon: Icons.event_outlined,
                  text: DateFormatter.short(task.endDate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DateLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
