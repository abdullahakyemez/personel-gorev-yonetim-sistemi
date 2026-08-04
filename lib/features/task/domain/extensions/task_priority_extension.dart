import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';

extension TaskPriorityExtension on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return "Düşük";

      case TaskPriority.normal:
        return "Normal";

      case TaskPriority.high:
        return "Yüksek";

      case TaskPriority.critical:
        return "Kritik";
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;

      case TaskPriority.normal:
        return Colors.blue;

      case TaskPriority.high:
        return Colors.orange;

      case TaskPriority.critical:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward;

      case TaskPriority.normal:
        return Icons.remove;

      case TaskPriority.high:
        return Icons.priority_high;

      case TaskPriority.critical:
        return Icons.warning_amber_rounded;
    }
  }
}
