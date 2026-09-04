import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/reports_provider.dart';
import '../../../task/domain/models/task_category.dart';
import '../../../task/domain/extensions/task_category_extension.dart';

class TaskReportSection extends ConsumerWidget {
  const TaskReportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(taskReportStatisticsProvider);
    return async.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
      error: (error, _) => Padding(padding: const EdgeInsets.all(16), child: Text('Görev raporu oluşturulurken hata oluştu:\n$error')),
      data: (statistics) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Görev Raporları', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 1100 ? 4 : constraints.maxWidth >= 700 ? 3 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.4,
                children: [
                  _ReportCard(title: 'Toplam Görev', value: statistics.totalTasks, icon: Icons.assignment_outlined),
                  for (final category in TaskCategory.values)
                    _ReportCard(title: category.label, value: statistics.categoryCounts[category.label] ?? 0, icon: Icons.assignment_turned_in_outlined),
                  _ReportCard(title: 'Tamamlanan', value: statistics.completedTasks, icon: Icons.check_circle_outline),
                  _ReportCard(title: 'Devam Eden', value: statistics.inProgressTasks, icon: Icons.play_circle_outline),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  const _ReportCard({required this.title, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('$value', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ])),
        ]),
      ),
    );
  }
}
