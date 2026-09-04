import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';

class TaskFormController {
  final formKey = GlobalKey<FormState>();

  // ------------------------------------------------------------
  // TEXT CONTROLLERS
  // ------------------------------------------------------------

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // ------------------------------------------------------------
  // SEÇİMLER
  // ------------------------------------------------------------

  TaskCategory? category;

  List<String> personnelIds = [];

  // ------------------------------------------------------------
  // TARİHLER
  // ------------------------------------------------------------

  DateTime? startDate;
  DateTime? endDate;

  // ------------------------------------------------------------
  // LOAD
  // ------------------------------------------------------------

  void load(Task task) {
    titleController.text = task.title;
    descriptionController.text = task.description;

    category = task.category;

    personnelIds = List<String>.from(task.personnelIds);

    startDate = task.startDate;
    endDate = task.endDate;

    startDateController.text = _formatDate(task.startDate);
    endDateController.text = _formatDate(task.endDate);
  }

  // ------------------------------------------------------------
  // TARİH FORMATLAMA
  // ------------------------------------------------------------

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // ------------------------------------------------------------
  // TARİH SEÇİMİ
  // ------------------------------------------------------------

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

    // Başlangıç tarihi değiştiğinde
    // mevcut bitiş tarihi daha önceyse onu da düzelt.
    if (endDate != null && endDate!.isBefore(picked)) {
      endDate = picked;
      endDateController.text = DateFormatter.short(picked);
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    endDate = picked;
    endDateController.text = DateFormatter.short(picked);
  }

  Task buildTask({String? id}) {
    return Task(
      id: id,
      personnelIds: List<String>.from(personnelIds),
      title: category?.label ?? titleController.text.trim(),
      description: descriptionController.text.trim(),
      status: Task.statusForDates(startDate!, endDate!),
      startDate: startDate!,
      endDate: endDate!,
    );
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }
}
