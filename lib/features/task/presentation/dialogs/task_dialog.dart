import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/forms/task_form.dart';

Future<void> showTaskDialog(
  BuildContext context, {
  Task? task,
  List<int>? initialPersonnelIds,
}) async {
  final isEdit = task != null;
  await showDialog(
    context: context,
    builder: (_) {
      return PGYSDialog(
        title: isEdit ? 'Görevi Düzenle' : 'Yeni Görev Ekle',
        subtitle: isEdit
            ? 'Görev detaylarını ve görevlendirilen personelleri güncelleyin'
            : 'Yeni bir görev tanımlayın ve personelleri görevlendirin',
        icon: Icons.assignment_outlined,
        scrollable: true,
        child: SizedBox(
          width: 680,
          child: TaskForm(
            task: task,
            initialPersonnelIds: initialPersonnelIds,
          ),
        ),
      );
    },
  );
}
