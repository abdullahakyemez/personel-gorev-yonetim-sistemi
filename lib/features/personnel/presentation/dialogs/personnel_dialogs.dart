import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_ids_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

Future<void> showAddPersonnelDialog(BuildContext context) async {
  final controller = PersonFormController();

  await showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Yeni Personel Kaydı",
      subtitle: "Birim kadrosuna yeni personel tanımlayınız",
      icon: Icons.person_add_alt_1_rounded,
      child: PersonForm(controller: controller),
    ),
  );

  controller.dispose();
}

Future<void> showEditPersonnelDialog(
  BuildContext context,
  Personnel person,
) async {
  final controller = PersonFormController();

  await showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Personel Bilgilerini Düzenle",
      subtitle: "${person.fullName} (Sicil: ${person.registryNumber})",
      icon: Icons.edit_note_rounded,
      child: PersonForm(controller: controller, personnel: person),
    ),
  );

  controller.dispose();
}

Future<void> showDeletePersonnelDialog(
  BuildContext context,
  WidgetRef ref,
  Personnel person,
) async {
  if (person.id == null) return;

  final leaves = ref.read(leaveControllerProvider).value ?? [];
  final tasks = ref.read(taskControllerProvider).value ?? [];

  final personnelLeaves =
      leaves.where((l) => l.personnelId == person.id).toList();
  final personnelTasks = tasks
      .where((t) => t.personnelIds.contains(person.id!))
      .toList();

  final details = <String>[];
  if (personnelLeaves.isNotEmpty) {
    details.add('${personnelLeaves.length} adet izin / rapor kaydı');
  }
  if (personnelTasks.isNotEmpty) {
    details.add('${personnelTasks.length} adet görev ataması');
  }

  final confirmed = await showPGYSConfirmDialog(
    context: context,
    title: 'Personel Sil',
    message:
        '${person.fullName} (Sicil: ${person.registryNumber}) isimli personeli silmek istediğinize emin misiniz?',
    details: details.isNotEmpty ? details : null,
    confirmText: 'Sil',
    cancelText: 'Vazgeç',
    isDestructive: true,
  );

  if (confirmed != true) return;

  try {
    final deletePersonnel = ref.read(deletePersonnelUseCaseProvider);
    await deletePersonnel(person.id!);

    ref.invalidate(personnelListProvider);
    ref.invalidate(selectedPersonnelProvider);
    if (ref.read(selectedPersonnelIdProvider) == person.id) {
      ref.read(selectedPersonnelIdProvider.notifier).state = null;
    }
    final currentIds = {...ref.read(selectedPersonnelIdsProvider)};
    if (currentIds.remove(person.id)) {
      ref.read(selectedPersonnelIdsProvider.notifier).state = currentIds;
    }
    ref.invalidate(leaveControllerProvider);
    ref.invalidate(taskControllerProvider);
    ref.invalidate(personnelHistoryProvider(person.id!));

    if (context.mounted) {
      PGYSFeedback.showSuccess(
        context,
        '${person.fullName} ve ilişkili kayıtlar başarıyla silindi.',
      );
    }
  } catch (error) {
    if (context.mounted) {
      PGYSFeedback.showError(
        context,
        'Personel silinirken bir hata oluştu: $error',
      );
    }
  }
}

Future<void> showDeleteManyPersonnelDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final ids = ref.read(selectedPersonnelIdsProvider);
  if (ids.isEmpty) return;

  final leaves = ref.read(leaveControllerProvider).value ?? [];
  final tasks = ref.read(taskControllerProvider).value ?? [];

  final affectedLeaves =
      leaves.where((l) => ids.contains(l.personnelId)).length;
  final affectedTasks =
      tasks.where((t) => t.personnelIds.any((id) => ids.contains(id))).length;

  final details = <String>[];
  if (affectedLeaves > 0) {
    details.add('$affectedLeaves adet izin / rapor kaydı');
  }
  if (affectedTasks > 0) {
    details.add('$affectedTasks adet görev ataması');
  }

  final confirmed = await showPGYSConfirmDialog(
    context: context,
    title: 'Toplu Personel Sil',
    message:
        'Seçili ${ids.length} personeli kalıcı olarak silmek istediğinize emin misiniz?',
    details: details.isNotEmpty ? details : null,
    confirmText: 'Sil (${ids.length})',
    cancelText: 'Vazgeç',
    isDestructive: true,
  );

  if (confirmed != true) return;

  try {
    final deleteManyPersonnel = ref.read(deleteManyPersonnelUseCaseProvider);
    await deleteManyPersonnel(ids.toList());

    ref.invalidate(personnelListProvider);
    ref.invalidate(selectedPersonnelProvider);
    ref.read(selectedPersonnelIdsProvider.notifier).state = {};
    final selectedId = ref.read(selectedPersonnelIdProvider);
    if (selectedId != null && ids.contains(selectedId)) {
      ref.read(selectedPersonnelIdProvider.notifier).state = null;
    }
    ref.invalidate(leaveControllerProvider);
    ref.invalidate(taskControllerProvider);
    for (final id in ids) {
      ref.invalidate(personnelHistoryProvider(id));
    }

    if (context.mounted) {
      PGYSFeedback.showSuccess(
        context,
        '${ids.length} personel ve ilişkili kayıtları başarıyla silindi.',
      );
    }
  } catch (error) {
    if (context.mounted) {
      PGYSFeedback.showError(
        context,
        'Personeller silinirken bir hata oluştu: $error',
      );
    }
  }
}
