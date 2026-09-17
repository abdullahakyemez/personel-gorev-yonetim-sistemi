import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/forms/task_form.dart';

Future<void> showTaskDialog(
  BuildContext context, {
  Task? task,
  List<int>? initialPersonnelIds,
}) async {
  await showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.all(32),
        child: SizedBox(width: 700, child: TaskForm(task: task, initialPersonnelIds: initialPersonnelIds)),
      );
    },
  );
}
