import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';

class TaskFormController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Dropdown Selections
  TaskPriority? priority;
  TaskStatus? status;

  // Diğer Alanlar
  DateTime? startDate;
  DateTime? endDate;

  String? personnelId;

  void load(Task task) {
    titleController.text = task.title;
    descriptionController.text = task.description;

    priority = task.priority;
    status = task.status;

    startDate = task.startDate;
    endDate = task.endDate;

    startDateController.text = _formatDate(task.startDate);
    endDateController.text = _formatDate(task.endDate);

    personnelId = task.personnelId;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}.${date.month}.${date.year}";
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    startDate = picked;
    startDateController.text = DateFormatter.short(picked);
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    endDate = picked;
    endDateController.text = DateFormatter.short(picked);
  }
}
