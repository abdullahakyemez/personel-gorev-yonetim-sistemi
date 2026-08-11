import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_actions.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_section.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/add_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/update_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

import '../../../domain/models/work_schedule.dart';

class PersonForm extends ConsumerStatefulWidget {
  final PersonFormController controller;
  final Personnel? personnel;

  const PersonForm({super.key, required this.controller, this.personnel});

  @override
  ConsumerState<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends ConsumerState<PersonForm> {
  @override
  void initState() {
    super.initState();

    if (widget.personnel != null) {
      widget.controller.load(widget.personnel!);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.fullNameFocus.requestFocus();
        }
      });
    }
  }

  Future<void> _selectStartDate() async {
    final controller = widget.controller;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.startDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.setStartDate(selectedDate);
    }
  }

  Future<void> _selectEndDate() async {
    final controller = widget.controller;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.endDate ?? DateTime.now(),
      firstDate: controller.startDate ?? DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.setEndDate(selectedDate);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Tarih seçiniz';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final addPersonnel = getIt<AddPersonnelUseCase>();
    final updatePersonnel = getIt<UpdatePersonnelUseCase>();

    final isEdit = widget.personnel != null;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;

        return PGYSForm(
          children: [
            // ============================================================
            // GENEL BİLGİLER
            // ============================================================
            PGYSFormSection(
              title: 'Genel Bilgiler',
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSTextField(
                      autoFocus: !isEdit,
                      label: 'Sicil',
                      controller: controller.registryNumberController,
                      keyboardType: TextInputType.number,
                      focusNode: controller.registryFocus,
                      nextFocusNode: controller.fullNameFocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    PGYSTextField(
                      label: 'Ad Soyad',
                      controller: controller.fullNameController,
                      focusNode: controller.fullNameFocus,
                      nextFocusNode: controller.phoneFocus,
                    ),

                    PGYSDropdownField<String>(
                      value: controller.selectedRank,
                      items: PersonnelLookup.ranks,
                      hint: 'Rütbe',
                      onChanged: controller.setRank,
                    ),

                    PGYSDropdownField<String>(
                      value: controller.selectedTitle,
                      items: PersonnelLookup.titles,
                      hint: 'Ünvan',
                      onChanged: controller.setTitle,
                    ),

                    PGYSDropdownField<PersonnelStatus>(
                      value: controller.status,
                      items: PersonnelStatus.values,
                      hint: 'Durum',
                      labelBuilder: (status) {
                        switch (status) {
                          case PersonnelStatus.duty:
                            return 'Görevde';

                          case PersonnelStatus.resting:
                            return 'İstirahatli';

                          case PersonnelStatus.leave:
                            return 'İzinli';

                          case PersonnelStatus.sickReport:
                            return 'Raporlu';
                        }
                      },
                      onChanged: (value) {
                        if (value != null) {
                          controller.setStatus(value);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            // ============================================================
            // KURUM BİLGİLERİ
            // ============================================================
            PGYSFormSection(
              title: 'Kurum Bilgileri',
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSDropdownField<String>(
                      value: controller.selectedDepartment,
                      items: PersonnelLookup.departments,
                      hint: 'Şube',
                      onChanged: controller.setDepartment,
                    ),

                    PGYSDropdownField<String>(
                      value: controller.selectedBranch,
                      items: PersonnelLookup.branches,
                      hint: 'Büro',
                      onChanged: controller.setBranch,
                    ),

                    _DateField(
                      label: 'Göreve Başlama',
                      text: _formatDate(controller.startDate),
                      required: true,
                      onTap: _selectStartDate,
                    ),

                    _DateField(
                      label: 'Görevden Ayrılma',
                      text: _formatDate(controller.endDate),
                      required: false,
                      onTap: _selectEndDate,
                      enabled: controller.startDate != null,
                    ),
                  ],
                ),
              ],
            ),

            // ============================================================
            // ÇALIŞMA DÜZENİ
            // ============================================================
            PGYSFormSection(
              title: 'Çalışma Düzeni',
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSDropdownField<WorkScheduleType>(
                      value: controller.workSchedule?.type,
                      items: WorkScheduleType.values,
                      hint: 'Çalışma Düzeni',
                      labelBuilder: (type) {
                        switch (type) {
                          case WorkScheduleType.twoPlusOne:
                            return '2+1';

                          case WorkScheduleType.onePlusOne:
                            return '1+1';

                          case WorkScheduleType.sixPlusOne:
                            return '6+1';

                          case WorkScheduleType.custom:
                            return 'Özel';
                        }
                      },
                      onChanged: (type) {
                        if (type == null) return;

                        int dutyDays;
                        int restDays;

                        switch (type) {
                          case WorkScheduleType.twoPlusOne:
                            dutyDays = 2;
                            restDays = 1;
                            break;

                          case WorkScheduleType.onePlusOne:
                            dutyDays = 1;
                            restDays = 1;
                            break;

                          case WorkScheduleType.sixPlusOne:
                            dutyDays = 6;
                            restDays = 1;
                            break;

                          case WorkScheduleType.custom:
                            return;
                        }

                        controller.setWorkSchedule(
                          WorkSchedule(
                            type: type,
                            dutyDays: dutyDays,
                            restDays: restDays,
                            startDate: controller.startDate ?? DateTime.now(),
                          ),
                        );
                      },
                    ),

                    _DateField(
                      label: 'Döngü Başlangıcı',
                      text: _formatDate(controller.workSchedule?.startDate),
                      enabled: controller.workSchedule != null,
                      onTap: () async {
                        if (controller.workSchedule == null) return;

                        final selected = await showDatePicker(
                          context: context,
                          initialDate: controller.workSchedule!.startDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );

                        if (selected != null) {
                          controller.setWorkSchedule(
                            controller.workSchedule!.copyWith(
                              startDate: selected,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            // ============================================================
            // İLETİŞİM BİLGİLERİ
            // ============================================================
            PGYSFormSection(
              title: 'İletişim Bilgileri',
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSTextField(
                      label: 'Telefon',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      focusNode: controller.phoneFocus,
                      textInputAction: TextInputAction.next,
                    ),

                    PGYSTextField(
                      label: 'Email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    PGYSTextField(
                      label: 'Adres',
                      controller: controller.addressController,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),

            // ============================================================
            // EK BİLGİLER
            // ============================================================
            PGYSFormSection(
              title: 'Ek Bilgiler',
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSTextField(
                      label: 'Kan Grubu',
                      controller: controller.bloodTypeController,
                    ),

                    PGYSTextField(
                      label: 'Yakını',
                      controller: controller.relativeNameController,
                    ),

                    PGYSTextField(
                      label: 'Yakın Telefonu',
                      controller: controller.relativePhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ],
            ),

            // ============================================================
            // AKSİYONLAR
            // ============================================================
            PGYSFormActions(
              saveText: isEdit ? 'Güncelle' : 'Kaydet',
              saveEnabled: controller.isValid,

              onCancel: () {
                Navigator.pop(context);
              },

              onSave: () async {
                if (!controller.isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen zorunlu alanları doldurun.'),
                    ),
                  );
                  return;
                }

                try {
                  if (isEdit) {
                    await updatePersonnel(controller.buildPersonnel());

                    ref.invalidate(personnelListProvider);

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Personel başarıyla güncellendi.'),
                      ),
                    );
                  } else {
                    await addPersonnel(controller.buildPersonnel());

                    ref.invalidate(personnelListProvider);

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Personel başarıyla eklendi.'),
                      ),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('İşlem sırasında hata oluştu: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// TARİH ALANI
// ============================================================================

class _DateField extends StatelessWidget {
  final String label;
  final String text;
  final bool required;
  final bool enabled;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.text,
    required this.onTap,
    this.required = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          enabled: enabled,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
