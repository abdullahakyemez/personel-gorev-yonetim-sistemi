import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

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
              // ------------------------------------------------------
              // BAŞLIK
              // ------------------------------------------------------
              Text(
                widget.leave == null ? 'Yeni İzin' : 'İzni Düzenle',

                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------------
              // PERSONEL
              // ------------------------------------------------------
              personnelAsync.when(
                data: (personnelList) {
                  return PGYSDropdownField<String>(
                    label: 'Personel',

                    hint: 'Personel Seçiniz',

                    value: controller.personnelId,

                    items: personnelList
                        .map((person) => person.registryNumber)
                        .toList(),

                    labelBuilder: (registryNumber) {
                      final person = personnelList.firstWhere(
                        (person) => person.registryNumber == registryNumber,
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
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),

                error: (_, _) => const Text('Personeller yüklenemedi'),
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------------
              // İZİN TÜRÜ
              // ------------------------------------------------------
              PGYSDropdownField<LeaveType>(
                label: 'İzin Türü',

                hint: 'İzin Türü Seçiniz',

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

              const SizedBox(height: 16),

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

                  const SizedBox(width: 16),

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

              const SizedBox(height: 16),

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

              const SizedBox(height: 24),

              // ------------------------------------------------------
              // BUTONLAR
              // ------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text('İptal'),
                  ),

                  const SizedBox(width: 12),

                  FilledButton(
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }

                      if (controller.personnelId == null ||
                          controller.type == null ||
                          controller.startDate == null ||
                          controller.endDate == null) {
                        return;
                      }

                      // Güvenlik kontrolü.
                      if (controller.endDate!.isBefore(controller.startDate!)) {
                        return;
                      }

                      final leave = Leave(
                        id:
                            widget.leave?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),

                        personnelId: controller.personnelId!,

                        startDate: controller.startDate!,

                        endDate: controller.endDate!,

                        type: controller.type!,

                        description: controller.descriptionController.text
                            .trim(),
                      );

                      if (widget.leave == null) {
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

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },

                    child: const Text('Kaydet'),
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
