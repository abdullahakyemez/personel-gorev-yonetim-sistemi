import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.waiting:
        return "Beklemede";

      case TaskStatus.inProgress:
        return "Devam Ediyor";

      case TaskStatus.completed:
        return "Tamamlandı";
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.waiting:
        return Colors.orange;

      case TaskStatus.inProgress:
        return Colors.blue;

      case TaskStatus.completed:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.waiting:
        return Icons.schedule;

      case TaskStatus.inProgress:
        return Icons.play_circle_outline;

      case TaskStatus.completed:
        return Icons.check_circle_outline;
    }
  }
}
