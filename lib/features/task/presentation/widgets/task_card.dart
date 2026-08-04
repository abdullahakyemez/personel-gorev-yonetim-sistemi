import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_priority_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool selected;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: PGYSCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(
                    task.priority.icon,
                    color: task.priority.color,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(task.priority.label),

                  const Spacer(),

                  Icon(task.status.icon, color: task.status.color, size: 18),

                  const SizedBox(width: 4),

                  Text(task.status.label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
