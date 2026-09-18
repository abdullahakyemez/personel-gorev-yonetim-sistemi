import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/section_card.dart';

import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_upcoming_tasks_provider.dart';

import 'upcoming_task_item.dart';

class UpcomingTaskCard extends ConsumerWidget {
  const UpcomingTaskCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(upcomingTasksProvider);
    final theme = Theme.of(context);

    return SectionCard(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.calendar_month_outlined,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: "Aktif ve Yaklaşan Görevler",
      subtitle: "Devam eden tedbir ve operasyonel görevler",
      trailing: TextButton(
        onPressed: () => context.go('/gorevler'),
        child: const Text(
          'Tümünü Gör',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      height: 450,
      scrollable: true,
      child: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Yaklaşan görev bulunmuyor',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return UpcomingTaskItem(task: tasks[index]);
            },
          );
        },
      ),
    );
  }
}
