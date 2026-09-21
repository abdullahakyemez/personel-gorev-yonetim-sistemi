import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/validators.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/forms/task_form_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';

class TaskForm extends ConsumerStatefulWidget {
  final Task? task;
  final List<int>? initialPersonnelIds;

  const TaskForm({super.key, this.task, this.initialPersonnelIds});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  late final TaskFormController controller;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _personnelScrollController = ScrollController();
  String _personnelFilter = '';

  @override
  void initState() {
    super.initState();

    controller = TaskFormController();

    if (widget.task != null) {
      controller.load(widget.task!);
    } else if (widget.initialPersonnelIds != null) {
      controller.personnelIds
        ..clear()
        ..addAll(widget.initialPersonnelIds!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _personnelScrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PGYSDropdownField<TaskCategory>(
              label: "Görev Türü",
              hint: "Görev türü seçiniz",
              prefixIcon: const Icon(Icons.category_outlined),
              value: controller.category,
              items: TaskCategory.values,
              labelBuilder: (item) => item.label,
              validator: (value) =>
                  value == null ? "Görev türü seçiniz." : null,
              onChanged: (value) =>
                  setState(() => controller.category = value),
            ),
            const SizedBox(height: AppSpacing.md),

            PGYSTextField(
              label: "Açıklama",
              controller: controller.descriptionController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.notes),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Açıklama zorunludur.";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: PGYSTextField(
                    label: "Başlangıç Tarihi",
                    controller: controller.startDateController,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.calendar_today),
                    onTap: () async {
                      await controller.pickStartDate(context);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PGYSTextField(
                    label: "Bitiş Tarihi",
                    controller: controller.endDateController,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.event),
                    onTap: () async {
                      await controller.pickEndDate(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            personnelAsync.when(
              data: (personnelList) {
                final query = _personnelFilter.trim().toLowerCase();
                final filteredPersonnel = personnelList.where((person) {
                  if (query.isEmpty) return true;
                  return person.fullName.toLowerCase().contains(query) ||
                      person.registryNumber.toLowerCase().contains(query) ||
                      person.rank.toLowerCase().contains(query) ||
                      person.department.toLowerCase().contains(query);
                }).toList();

                final allFilteredSelected = filteredPersonnel.isNotEmpty &&
                    filteredPersonnel.every((p) =>
                        p.id != null && controller.personnelIds.contains(p.id));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar with Count & Bulk Select / Clear Actions
                    Row(
                      children: [
                        Text(
                          'Görev Atanacak Personeller',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: controller.personnelIds.isEmpty
                                ? Theme.of(context)
                                     .colorScheme
                                     .outlineVariant
                                     .withValues(alpha: 0.3)
                                : Theme.of(context)
                                     .colorScheme
                                     .primaryContainer
                                     .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${controller.personnelIds.length} seçildi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: controller.personnelIds.isEmpty
                                  ? Theme.of(context).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          ),
                          icon: Icon(
                            allFilteredSelected
                                ? Icons.deselect_outlined
                                : Icons.select_all_outlined,
                            size: 16,
                          ),
                          label: Text(
                            allFilteredSelected ? 'Seçimi Kaldır' : 'Tümünü Seç',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              if (allFilteredSelected) {
                                for (final p in filteredPersonnel) {
                                  if (p.id != null) {
                                    controller.personnelIds.remove(p.id);
                                  }
                                }
                              } else {
                                for (final p in filteredPersonnel) {
                                  if (p.id != null &&
                                      !controller.personnelIds.contains(p.id)) {
                                    controller.personnelIds.add(p.id!);
                                  }
                                }
                              }
                            });
                          },
                        ),
                        if (controller.personnelIds.isNotEmpty) ...[
                          const SizedBox(width: AppSpacing.xs),
                          TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.personnelIds.clear();
                              });
                            },
                            child: const Text(
                              'Temizle',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Fixed-height container with search input & scrollable list
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLowest,
                        border: Border.all(
                          color: controller.personnelIds.isEmpty
                              ? Theme.of(context).colorScheme.outlineVariant
                              : Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Search Box
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText:
                                      'Personel ara (Ad, Soyad, Sicil, Rütbe)...',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                                  prefixIcon: const Icon(Icons.search, size: 18),
                                  suffixIcon: _personnelFilter.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                              _personnelFilter = '';
                                            });
                                          },
                                        )
                                      : null,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _personnelFilter = val;
                                  });
                                },
                              ),
                            ),
                          ),

                          const Divider(height: 1),

                          // Scrollable Personnel List
                          Expanded(
                            child: filteredPersonnel.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppSpacing.md),
                                      child: Text(
                                        _personnelFilter.isEmpty
                                            ? 'Kayıtlı personel bulunmuyor.'
                                            : 'Kriterlere uygun personel bulunamadı.',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                    ),
                                  )
                                : Scrollbar(
                                    controller: _personnelScrollController,
                                    thumbVisibility: true,
                                    child: ListView.separated(
                                      controller: _personnelScrollController,
                                      itemCount: filteredPersonnel.length,
                                      separatorBuilder: (_, _) =>
                                          const Divider(height: 1, indent: 48),
                                      itemBuilder: (context, index) {
                                        final person = filteredPersonnel[index];
                                        final personId = person.id;
                                        final isSelected = personId != null &&
                                            controller.personnelIds
                                                .contains(personId);

                                        return InkWell(
                                          onTap: personId == null
                                              ? null
                                              : () {
                                                  setState(() {
                                                    if (isSelected) {
                                                      controller.personnelIds
                                                          .remove(personId);
                                                    } else {
                                                      controller.personnelIds
                                                          .add(personId);
                                                    }
                                                  });
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.md,
                                              vertical: AppSpacing.sm,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: AppSpacing.lg,
                                                  height: AppSpacing.lg,
                                                  child: Checkbox(
                                                    value: isSelected,
                                                    onChanged: personId == null
                                                        ? null
                                                        : (bool? val) {
                                                            setState(() {
                                                              if (val == true) {
                                                                controller
                                                                    .personnelIds
                                                                    .add(personId);
                                                              } else {
                                                                controller
                                                                    .personnelIds
                                                                    .remove(
                                                                        personId);
                                                              }
                                                            });
                                                          },
                                                  ),
                                                ),
                                                 const SizedBox(width: AppSpacing.sm),
                                                 CircleAvatar(
                                                   radius: 14,
                                                   backgroundColor: isSelected
                                                       ? const Color(0xFF0F2027)
                                                       : Theme.of(context)
                                                           .colorScheme
                                                           .surfaceContainerHighest,
                                                   foregroundColor: isSelected
                                                       ? Colors.white
                                                       : Theme.of(context)
                                                           .colorScheme
                                                           .onSurfaceVariant,
                                                   child: Text(
                                                     person.fullName.isNotEmpty
                                                         ? person.fullName[0]
                                                             .toUpperCase()
                                                         : 'P',
                                                     style: const TextStyle(
                                                       fontSize: 11,
                                                       fontWeight:
                                                           FontWeight.bold,
                                                     ),
                                                   ),
                                                 ),
                                                 const SizedBox(width: AppSpacing.sm),
                                                 Expanded(
                                                   child: Column(
                                                     crossAxisAlignment:
                                                         CrossAxisAlignment.start,
                                                     mainAxisSize:
                                                         MainAxisSize.min,
                                                     children: [
                                                       Text(
                                                         person.fullName,
                                                         style: TextStyle(
                                                           fontSize: 13,
                                                           fontWeight: isSelected
                                                               ? FontWeight.w700
                                                               : FontWeight.w500,
                                                         ),
                                                       ),
                                                       Text(
                                                         '${person.rank} • Sicil: ${person.registryNumber}',
                                                         style: TextStyle(
                                                           fontSize: 11,
                                                           color: Theme.of(context)
                                                               .colorScheme
                                                               .onSurfaceVariant,
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         );
                                       },
                                     ),
                                   ),
                           ),
                         ],
                       ),
                     ),

                      if (controller.personnelIds.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.xs),
                          child: Text(
                            'En az bir personel seçiniz.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Text('Personeller yüklenemedi'),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("İptal"),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  FilledButton(
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }

                      if (controller.category == null) {
                        PGYSFeedback.showWarning(
                          context,
                          'Lütfen bir görev türü seçiniz.',
                        );
                        return;
                      }

                      if (controller.personnelIds.isEmpty) {
                        PGYSFeedback.showWarning(
                          context,
                          'Lütfen göreve en az bir personel atayınız.',
                        );
                        return;
                      }

                      if (controller.startDate == null ||
                          controller.endDate == null) {
                        PGYSFeedback.showWarning(
                          context,
                          'Lütfen başlangıç ve bitiş tarihlerini seçiniz.',
                        );
                        return;
                      }

                      final dateOrderError = Validators.dateOrder(
                        controller.startDate,
                        controller.endDate,
                      );
                      if (dateOrderError != null) {
                        PGYSFeedback.showError(context, dateOrderError);
                        return;
                      }

                      try {
                        final task = controller.buildTask(
                          id: widget.task?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                        );

                        final isEdit = widget.task != null;
                        if (!isEdit) {
                          await ref
                              .read(taskControllerProvider.notifier)
                              .addTask(task);
                        } else {
                          await ref
                              .read(taskControllerProvider.notifier)
                              .updateTask(task);
                        }

                        ref.read(selectedTaskIdProvider.notifier).state =
                            task.id;

                        if (context.mounted) {
                          Navigator.pop(context);
                          PGYSFeedback.showSuccess(
                            context,
                            isEdit
                                ? 'Görev başarıyla güncellendi.'
                                : 'Görev başarıyla eklendi.',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          PGYSFeedback.showError(
                            context,
                            'Görev kaydedilemedi: $e',
                          );
                        }
                      }
                    },
                    child: const Text("Kaydet"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
