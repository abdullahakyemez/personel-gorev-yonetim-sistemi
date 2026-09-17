import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_ids_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/dialogs/task_dialog.dart';

class PersonnelSelectionToolbar extends ConsumerWidget {
  const PersonnelSelectionToolbar({super.key});

  Future<void> _assignTask(BuildContext context, WidgetRef ref) async {
    final selectedIds = ref.read(selectedPersonnelIdsProvider);
    if (selectedIds.isEmpty) return;

    if (!context.mounted) return;

    await showTaskDialog(
      context,
      initialPersonnelIds: selectedIds.toList(),
    );
  }

  Future<void> _exportSelected(BuildContext context, WidgetRef ref) async {
    final selectedIds = ref.read(selectedPersonnelIdsProvider);
    if (selectedIds.isEmpty) return;

    try {
      final personnel = await ref.read(personnelListProvider.future);
      final selectedPersonnel = personnel
          .where((person) => person.id != null && selectedIds.contains(person.id))
          .toList();

      final path = await PersonnelExcelExportService().export(
        personnel: selectedPersonnel,
      );

      if (!context.mounted || path == null) return;
      PGYSFeedback.showSuccess(
        context,
        'Excel dosyası kaydedildi: $path',
      );
    } catch (error) {
      if (!context.mounted) return;
      PGYSFeedback.showError(
        context,
        'Excel aktarımı başarısız: $error',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedPersonnelIdsProvider);
    final hasSelection = selected.isNotEmpty;

    final canDelete = ref.watch(hasPermissionProvider(AppPermission.deletePersonnel));
    final canAssignTask = ref.watch(hasPermissionProvider(AppPermission.createTask));
    final canExport = ref.watch(hasPermissionProvider(AppPermission.exportReports));

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20),
          const SizedBox(width: 8),
          Text(
            '${selected.length} Personel Seçildi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          if (canDelete) ...[
            FilledButton.icon(
              onPressed: hasSelection
                  ? () => showDeleteManyPersonnelDialog(context, ref)
                  : null,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Sil'),
            ),
            const SizedBox(width: 8),
          ],
          if (canAssignTask) ...[
            FilledButton.icon(
              onPressed: hasSelection ? () => _assignTask(context, ref) : null,
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Görev Ata'),
            ),
            const SizedBox(width: 8),
          ],
          if (canExport) ...[
            FilledButton.icon(
              onPressed: hasSelection ? () => _exportSelected(context, ref) : null,
              icon: const Icon(Icons.file_download_outlined),
              label: const Text('Excel'),
            ),
            const SizedBox(width: 8),
          ],
          TextButton.icon(
            onPressed: () {
              ref.read(selectedPersonnelIdsProvider.notifier).state = {};
            },
            icon: const Icon(Icons.close),
            label: const Text('Vazgeç'),
          ),
        ],
      ),
    );
  }
}
