import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/dialogs/task_dialog.dart';

import 'task_status_chip.dart';

class TaskDetailPanel extends ConsumerWidget {
  const TaskDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(selectedTaskProvider);
    final canEditTask = ref.watch(hasPermissionProvider(AppPermission.editTask));
    final canDeleteTask =
        ref.watch(hasPermissionProvider(AppPermission.deleteTask));

    if (task == null) {
      return const Center(
        child: Text('Görev seçiniz', style: TextStyle(fontSize: 16)),
      );
    }

    final personnelAsync = ref.watch(personnelListProvider);

    return personnelAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Personel bilgileri yüklenemedi.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
      data: (personnelList) {
        final assignedPersonnel = personnelList
            .where(
              (personnel) =>
                  personnel.id != null &&
                  task.personnelIds.contains(personnel.id),
            )
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: PGYSCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Kurumsal Başlık Kartı (PersonnelProfileCard stili)
                _buildCorporateHeader(
                  context,
                  ref,
                  task,
                  canEditTask,
                  canDeleteTask,
                ),

                const SizedBox(height: 20),

                // 2. Durum ve Tarih Metrikleri
                _buildMetricsSection(context, task, assignedPersonnel.length),

                const SizedBox(height: 20),

                // 3. Görevli Personeller Bölümü
                _buildPersonnelSection(context, ref, assignedPersonnel),

                const SizedBox(height: 20),

                // 4. Görev Açıklaması Bölümü
                _buildDescriptionSection(context, task),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Kurumsal Başlık Kartı
  // ---------------------------------------------------------------------------
  Widget _buildCorporateHeader(
    BuildContext context,
    WidgetRef ref,
    Task task,
    bool canEditTask,
    bool canDeleteTask,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF223E47),
            Color(0xFF14252B),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E353D),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF4DD0E1),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Detayı kapat',
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () {
                            ref.read(selectedTaskIdProvider.notifier).state =
                                null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Görev Detayı',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4DD0E1)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.category?.label ?? 'Genel Görev',
                            style: const TextStyle(
                              color: Color(0xFF4DD0E1),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (canEditTask || canDeleteTask) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canEditTask) ...[
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text(
                      'Düzenle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => showTaskDialog(context, task: task),
                  ),
                  const SizedBox(width: 8),
                ],
                if (canDeleteTask) ...[
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF8B2B38)
                          .withValues(alpha: 0.6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 14,
                    ),
                    label: const Text(
                      'Sil',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _handleDeleteTask(context, ref, task),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Metrik Kartları (Durum, Başlangıç, Bitiş, Süre)
  // ---------------------------------------------------------------------------
  Widget _buildMetricsSection(BuildContext context, Task task, int personnelCount) {
    final daysCount = task.endDate.difference(task.startDate).inDays + 1;

    return Row(
      children: [
        // Durum Kartı
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DURUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                TaskStatusChip(status: task.status),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Tarihler Kartı
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TARİH ARALIĞI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$daysCount gün',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${DateFormatter.short(task.startDate)} - ${DateFormatter.short(task.endDate)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Görevli Personeller
  // ---------------------------------------------------------------------------
  Widget _buildPersonnelSection(
    BuildContext context,
    WidgetRef ref,
    List<Personnel> assignedPersonnel,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Görevli Personeller',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: assignedPersonnel.isEmpty
                      ? Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)
                      : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${assignedPersonnel.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: assignedPersonnel.isEmpty
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (assignedPersonnel.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Bu göreve atanmış herhangi bir personel bulunmuyor.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: assignedPersonnel.map((person) {
                final initials = person.fullName.isNotEmpty
                    ? person.fullName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                    : 'P';

                return ActionChip(
                  avatar: CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF0F2027),
                    foregroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  label: Text(
                    person.fullName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tooltip: '${person.fullName} profiline git',
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  onPressed: () {
                    if (person.id != null) {
                      ref.read(selectedPersonnelIdProvider.notifier).state = person.id;
                      context.go('/personeller');
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Görev Açıklaması
  // ---------------------------------------------------------------------------
  Widget _buildDescriptionSection(BuildContext context, Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Açıklama',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            task.description.trim().isEmpty ? 'Açıklama belirtilmemiş.' : task.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Silme Onay İşlemi
  // ---------------------------------------------------------------------------
  Future<void> _handleDeleteTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    if (task.id == null) return;

    final assignedCount = task.personnelIds.length;
    final details = <String>[];
    if (assignedCount > 0) {
      details.add('$assignedCount personele ait görev ataması kaldırılacaktır');
    }

    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Görevi Sil',
      message:
          '"${task.title}" başlıklı görevi silmek istediğinize emin misiniz?',
      details: details.isNotEmpty ? details : null,
      confirmText: 'Sil',
      cancelText: 'Vazgeç',
      isDestructive: true,
    );

    if (confirmed != true) return;

    await ref.read(taskControllerProvider.notifier).deleteTask(task.id!);
    ref.read(selectedTaskIdProvider.notifier).state = null;

    if (context.mounted) {
      PGYSFeedback.showSuccess(
        context,
        '"${task.title}" görevi başarıyla silindi.',
      );
    }
  }
}

