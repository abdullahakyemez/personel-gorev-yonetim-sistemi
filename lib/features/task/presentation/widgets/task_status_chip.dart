import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';

class TaskStatusChip extends StatelessWidget {
  final TaskStatus status;

  const TaskStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(status.icon, color: status.color, size: 18),
      label: Text(status.label),
      backgroundColor: status.color.withValues(alpha: 0.12),
    );
  }
}
