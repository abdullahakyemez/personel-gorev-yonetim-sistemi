import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/dialogs/task_dialog.dart';

class TaskTableRow extends ConsumerWidget {
  final Task task;
  final bool isSelected;
  final VoidCallback? onTap;

  const TaskTableRow({
    super.key,
    required this.task,
    required this.isSelected,
    this.onTap,
  });

  Color _categoryBgColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('tedbir')) return const Color(0xFFE1F5FE);
    if (l.contains('müsabaka') || l.contains('musabaka')) return const Color(0xFFE8F5E9);
    if (l.contains('uygulama')) return const Color(0xFFF3E5F5);
    if (l.contains('sınav') || l.contains('sinav')) return const Color(0xFFFFF8E1);
    if (l.contains('il dışı') || l.contains('il disi')) return const Color(0xFFFFEBEE);
    return const Color(0xFFECEFF1);
  }

  Color _categoryBorderColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('tedbir')) return const Color(0xFF81D4FA);
    if (l.contains('müsabaka') || l.contains('musabaka')) return const Color(0xFFA5D6A7);
    if (l.contains('uygulama')) return const Color(0xFFCE93D8);
    if (l.contains('sınav') || l.contains('sinav')) return const Color(0xFFFFE082);
    if (l.contains('il dışı') || l.contains('il disi')) return const Color(0xFFFFCDD2);
    return const Color(0xFFCFD8DC);
  }

  Color _categoryTextColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('tedbir')) return const Color(0xFF0288D1);
    if (l.contains('müsabaka') || l.contains('musabaka')) return const Color(0xFF2E7D32);
    if (l.contains('uygulama')) return const Color(0xFF7B1FA2);
    if (l.contains('sınav') || l.contains('sinav')) return const Color(0xFFE65100);
    if (l.contains('il dışı') || l.contains('il disi')) return const Color(0xFFC62828);
    return const Color(0xFF455A64);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  String _formatTimeRange(DateTime s, DateTime e) =>
      '${s.hour.toString().padLeft(2, '0')}:${s.minute.toString().padLeft(2, '0')} - '
      '${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final personnelAsync = ref.watch(personnelListProvider);
    final canEditTask = ref.watch(hasPermissionProvider(AppPermission.editTask));
    final canDeleteTask = ref.watch(hasPermissionProvider(AppPermission.deleteTask));

    final isCompleted = task.status == TaskStatus.completed;

    final personnelNames = personnelAsync.when(
      data: (list) {
        final pMap = {for (final p in list) if (p.id != null) p.id!: p.fullName};
        return task.personnelIds.map((id) => pMap[id] ?? 'Sicil: $id').join(', ');
      },
      loading: () => 'Yükleniyor...',
      error: (_, _) => 'Yüklenemedi',
    );

    final categoryLabel = task.category?.label ?? 'Genel';

    return InkWell(
      onTap: onTap,
      hoverColor: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 1. DURUM
            SizedBox(
              width: 120,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFFA5D6A7)
                        : const Color(0xFFFFE082),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_outline_rounded
                          : Icons.access_time_rounded,
                      size: 14,
                      color: isCompleted
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        isCompleted ? 'Tamamlandı' : 'Devam Ediyor',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. GÖREV BAŞLIĞI
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 3. KATEGORİ
            SizedBox(
              width: 90,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _categoryBgColor(categoryLabel),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _categoryBorderColor(categoryLabel),
                    ),
                  ),
                  child: Text(
                    categoryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _categoryTextColor(categoryLabel),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 4. TARİH / SAAT
            SizedBox(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDate(task.startDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimeRange(task.startDate, task.endDate),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 5. GÖREVLENDİRİLEN PERSONEL
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${task.personnelIds.length} Personel',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      personnelNames,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // 6. İŞLEMLER
            SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: 'Görüntüle',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ref.read(selectedTaskIdProvider.notifier).state = task.id;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 17,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (canEditTask)
                    Tooltip(
                      message: 'Düzenle',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => showTaskDialog(context, task: task),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 17,
                            color: Color(0xFF1E5F74),
                          ),
                        ),
                      ),
                    ),
                  if (canDeleteTask)
                    Tooltip(
                      message: 'Sil',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final confirmed = await showPGYSConfirmDialog(
                            context: context,
                            title: 'Görevi Sil',
                            message:
                                '"${task.title}" başlıklı görevi silmek istediğinize emin misiniz?',
                            confirmText: 'Sil',
                            cancelText: 'Vazgeç',
                            isDestructive: true,
                          );

                          if (confirmed == true && task.id != null) {
                            await ref
                                .read(taskControllerProvider.notifier)
                                .deleteTask(task.id!);
                            if (ref.read(selectedTaskIdProvider) == task.id) {
                              ref.read(selectedTaskIdProvider.notifier).state =
                                  null;
                            }
                            if (context.mounted) {
                              PGYSFeedback.showSuccess(
                                context,
                                '"${task.title}" görevi başarıyla silindi.',
                              );
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
