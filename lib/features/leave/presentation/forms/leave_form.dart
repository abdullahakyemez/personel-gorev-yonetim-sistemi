import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/validators.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/services/leave_overlap.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/dialogs/leave_document_export_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

import 'leave_form_controller.dart';

class LeaveForm extends ConsumerStatefulWidget {
  final Leave? leave;

  const LeaveForm({super.key, this.leave});

  @override
  ConsumerState<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends ConsumerState<LeaveForm> {
  late final LeaveFormController controller;

  @override
  void initState() {
    super.initState();

    controller = LeaveFormController();

    if (widget.leave != null) {
      controller.load(widget.leave!);
    }
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> _exportLeaveDocument() async {
    if (!controller.formKey.currentState!.validate()) return;

    if (controller.personnelId == null ||
        controller.type == null ||
        controller.startDate == null ||
        controller.endDate == null ||
        controller.endDate!.isBefore(controller.startDate!)) {
      return;
    }

    try {
      final personnel = await ref.read(personnelListProvider.future);
      final person = personnel.firstWhere(
        (item) => item.id == controller.personnelId,
      );

      final leave = Leave(
        id: widget.leave?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        personnelId: controller.personnelId!,
        startDate: controller.startDate!,
        endDate: controller.endDate!,
        type: controller.type!,
        description: controller.descriptionController.text.trim(),
        address: controller.addressController.text.trim(),
      );

      if (!mounted) return;
      await LeaveDocumentExportDialog.show(
        context,
        leave: leave,
        person: person,
      );
    } catch (error) {
      if (!mounted) return;
      PGYSFeedback.showError(
        context,
        'İzin belgesi oluşturulamadı: $error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

              // ------------------------------------------------------
              // PERSONEL
              // ------------------------------------------------------
              personnelAsync.when(
                data: (personnelList) {
                  return PGYSDropdownField<int>(
                    label: 'Personel',
                    hint: 'Personel Seçiniz',
                    prefixIcon: const Icon(Icons.person_outline),
                    value: controller.personnelId,
                    items: personnelList
                        .map((person) => person.id)
                        .whereType<int>()
                        .toList(),
                    labelBuilder: (personnelId) {
                      final person = personnelList.firstWhere(
                        (person) => person.id == personnelId,
                      );

                      return person.fullName;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Personel seçiniz.';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        controller.personnelId = value;
                      });
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                ),
                error: (_, _) => const Text('Personeller yüklenemedi'),
              ),

              const SizedBox(height: AppSpacing.md),

              PGYSTextField(
                label: 'İznini Geçireceği Adres',
                controller: controller.addressController,
                maxLines: 3,
                prefixIcon: const Icon(Icons.home_outlined),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'İzin adresi zorunludur.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // ------------------------------------------------------
              // İZİN TÜRÜ
              // ------------------------------------------------------
              PGYSDropdownField<LeaveType>(
                label: 'İzin Türü',
                hint: 'İzin Türü Seçiniz',
                prefixIcon: const Icon(Icons.category_outlined),
                value: controller.type,
                items: LeaveType.values,
                labelBuilder: (type) => type.label,
                validator: (value) {
                  if (value == null) {
                    return 'İzin türü seçiniz.';
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    controller.type = value;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // ------------------------------------------------------
              // TARİHLER
              // ------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: PGYSTextField(
                      label: 'Başlangıç Tarihi',

                      controller: controller.startDateController,

                      readOnly: true,

                      prefixIcon: const Icon(Icons.calendar_today),

                      validator: (_) {
                        if (controller.startDate == null) {
                          return 'Tarih seçiniz.';
                        }

                        return null;
                      },

                      onTap: () async {
                        await controller.pickStartDate(context);

                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: PGYSTextField(
                      label: 'Bitiş Tarihi',

                      controller: controller.endDateController,

                      readOnly: true,

                      prefixIcon: const Icon(Icons.event),

                      validator: (_) {
                        if (controller.endDate == null) {
                          return 'Tarih seçiniz.';
                        }

                        return null;
                      },

                      onTap: () async {
                        await controller.pickEndDate(context);

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ------------------------------------------------------
              // AÇIKLAMA
              // ------------------------------------------------------
              PGYSTextField(
                label: 'Açıklama',

                controller: controller.descriptionController,

                maxLines: 4,

                prefixIcon: const Icon(Icons.notes),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Açıklama zorunludur.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // ------------------------------------------------------
              // BUTONLAR
              // ------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  OutlinedButton.icon(
                    onPressed: _exportLeaveDocument,
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('İzin Belgesi'),
                  ),

                  const Spacer(),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('İptal'),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  FilledButton(
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }

                      if (controller.personnelId == null) {
                        PGYSFeedback.showWarning(
                          context,
                          'Lütfen bir personel seçiniz.',
                        );
                        return;
                      }

                      if (controller.type == null) {
                        PGYSFeedback.showWarning(
                          context,
                          'Lütfen bir izin türü seçiniz.',
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

                      // Çakışan izin kontrolü (LeaveOverlap)
                      final allLeaves =
                          ref.read(leaveControllerProvider).value ?? [];
                      final conflict = LeaveOverlap.findConflict(
                        leaves: allLeaves,
                        personnelId: controller.personnelId!,
                        startDate: controller.startDate!,
                        endDate: controller.endDate!,
                        excludeId: widget.leave?.id,
                      );

                      if (conflict != null) {
                        PGYSFeedback.showWarning(
                          context,
                          'Bu personelin belirtilen tarihlerde zaten bir ${conflict.type.label} kaydı bulunmaktadır '
                          '(${DateFormatter.short(conflict.startDate)} - ${DateFormatter.short(conflict.endDate)}).',
                          title: 'İzin Çakışması',
                          duration: const Duration(seconds: 5),
                        );
                        return;
                      }

                      try {
                        final leave = Leave(
                          id: widget.leave?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          personnelId: controller.personnelId!,
                          startDate: controller.startDate!,
                          endDate: controller.endDate!,
                          type: controller.type!,
                          description:
                              controller.descriptionController.text.trim(),
                          address: controller.addressController.text.trim(),
                        );

                        final isEdit = widget.leave != null;
                        if (!isEdit) {
                          await ref
                              .read(leaveControllerProvider.notifier)
                              .addLeave(leave);
                        } else {
                          await ref
                              .read(leaveControllerProvider.notifier)
                              .updateLeave(leave);
                        }

                        ref.read(selectedLeaveIdProvider.notifier).state =
                            leave.id;
                        ref.invalidate(personnelListProvider);

                        if (context.mounted) {
                          Navigator.pop(context);
                          PGYSFeedback.showSuccess(
                            context,
                            isEdit
                                ? 'İzin kaydı başarıyla güncellendi.'
                                : 'İzin kaydı başarıyla eklendi.',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          PGYSFeedback.showError(
                            context,
                            'İzin kaydedilemedi: $e',
                          );
                        }
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
