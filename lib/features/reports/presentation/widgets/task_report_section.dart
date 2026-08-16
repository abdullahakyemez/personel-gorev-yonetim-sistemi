import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/reports_provider.dart';

class TaskReportSection extends ConsumerWidget {
  const TaskReportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(taskReportStatisticsProvider);

    return statisticsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Görev raporu oluşturulurken hata oluştu:\n$error'),
      ),
      data: (statistics) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Görev Raporları',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final crossAxisCount = width >= 1100
                    ? 5
                    : width >= 700
                    ? 3
                    : 2;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.4,
                  children: [
                    _ReportCard(
                      title: 'Toplam Görev',
                      value: statistics.totalTasks,
                      icon: Icons.assignment_outlined,
                    ),
                    _ReportCard(
                      title: 'Tamamlanan',
                      value: statistics.completedTasks,
                      icon: Icons.task_alt_outlined,
                    ),
                    _ReportCard(
                      title: 'Devam Eden',
                      value: statistics.inProgressTasks,
                      icon: Icons.pending_actions_outlined,
                    ),
                    _ReportCard(
                      title: 'Bekleyen',
                      value: statistics.waitingTasks,
                      icon: Icons.hourglass_empty_outlined,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            _TaskPerformanceCard(
              total: statistics.totalTasks,
              completed: statistics.completedTasks,
              inProgress: statistics.inProgressTasks,
              waiting: statistics.waitingTasks,
            ),
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

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$value',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskPerformanceCard extends StatelessWidget {
  final int total;
  final int completed;
  final int inProgress;
  final int waiting;

  const _TaskPerformanceCard({
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.waiting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completedPercent = total == 0 ? 0.0 : completed / total;

    final inProgressPercent = total == 0 ? 0.0 : inProgress / total;

    final waitingPercent = total == 0 ? 0.0 : waiting / total;

    //final overduePercent = total == 0 ? 0.0 : overdue / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Görev Performansı', style: theme.textTheme.titleMedium),

            const SizedBox(height: 20),

            _PerformanceRow(
              label: 'Tamamlanan',
              value: completed,
              percentage: completedPercent,
            ),

            const SizedBox(height: 12),

            _PerformanceRow(
              label: 'Devam Eden',
              value: inProgress,
              percentage: inProgressPercent,
            ),

            const SizedBox(height: 12),

            _PerformanceRow(
              label: 'Bekleyen',
              value: waiting,
              percentage: waitingPercent,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final int value;
  final double percentage;

  const _PerformanceRow({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: percentage, minHeight: 10),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 45,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 50,
          child: Text(
            '${(percentage * 100).toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
