import 'package:flutter/material.dart';
import '../models/task_status.dart';

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.inProgress:
        return 'Devam Ediyor';
      case TaskStatus.completed:
        return 'Tamamlandı';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
    }
  }
}
