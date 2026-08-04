import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_priority_extension.dart';

class TaskPriorityChip extends StatelessWidget {
  final TaskPriority priority;

  const TaskPriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(priority.icon, color: priority.color, size: 18),
      label: Text(priority.label),
      backgroundColor: priority.color.withValues(alpha: 0.12),
    );
  }
}
