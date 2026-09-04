import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final List<String>? initialPersonnelIds;

  const TaskForm({super.key, this.task, this.initialPersonnelIds});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  late final TaskFormController controller;

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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelListProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: controller.formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.task == null ? "Yeni Görev" : "Görevi Düzenle",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 24),

              PGYSDropdownField<TaskCategory>(
                label: "Görev Türü",
                hint: "Görev türü seçiniz",
                value: controller.category,
                items: TaskCategory.values,
                labelBuilder: (item) => item.label,
                validator: (value) =>
                    value == null ? "Görev türü seçiniz." : null,
                onChanged: (value) =>
                    setState(() => controller.category = value),
              ),
              const SizedBox(height: 16),

              PGYSTextField(
                label: "Açıklama",
                controller: controller.descriptionController,
                maxLines: 4,
                prefixIcon: const Icon(Icons.notes),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Açıklama zorunludur.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

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
                  const SizedBox(width: 16),
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

              const SizedBox(height: 24),

              personnelAsync.when(
                data: (personnelList) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Görev Atanacak Personeller',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: personnelList.map((person) {
                            final selected = controller.personnelIds.contains(
                              person.registryNumber,
                            );

                            return CheckboxListTile(
                              value: selected,
                              title: Text(person.fullName),
                              subtitle: Text(person.registryNumber),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    if (!controller.personnelIds.contains(
                                      person.registryNumber,
                                    )) {
                                      controller.personnelIds.add(
                                        person.registryNumber,
                                      );
                                    }
                                  } else {
                                    controller.personnelIds.remove(
                                      person.registryNumber,
                                    );
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      if (controller.personnelIds.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'En az bir personel seçiniz.',
                            style: TextStyle(
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("İptal"),
                  ),

                  const SizedBox(width: 12),

                  FilledButton(
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }

                      if (controller.category == null ||
                          controller.personnelIds.isEmpty ||
                          controller.startDate == null ||
                          controller.endDate == null) {
                        return;
                      }

                      final task = controller.buildTask(
                        id:
                            widget.task?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                      );

                      if (widget.task == null) {
                        await ref
                            .read(taskControllerProvider.notifier)
                            .addTask(task);
                      } else {
                        await ref
                            .read(taskControllerProvider.notifier)
                            .updateTask(task);
                      }

                      ref.read(selectedTaskIdProvider.notifier).state = task.id;

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Kaydet"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
