import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_section.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_actions.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/add_personnel_usecase.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

class PersonForm extends ConsumerWidget {
  final PersonFormController controller;

  const PersonForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addPersonnel = getIt<AddPersonnelUseCase>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return PGYSForm(
          children: [
            PGYSFormSection(
              title: "Genel Bilgiler",
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSTextField(
                      autoFocus: true,
                      label: "Ad Soyad",
                      controller: controller.fullNameController,
                      focusNode: controller.fullNameFocus,
                      nextFocusNode: controller.registryFocus,
                    ),
                    PGYSTextField(
                      label: "Sicil",
                      controller: controller.registryController,
                      keyboardType: TextInputType.number,
                      focusNode: controller.registryFocus,
                      nextFocusNode: controller.phoneFocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    PGYSTextField(
                      label: "Telefon",
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      focusNode: controller.phoneFocus,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ],
            ),
            PGYSFormSection(
              title: "Kurum Bilgileri",
              children: [
                PGYSFormGrid(
                  children: [
                    PGYSDropdownField<String>(
                      value: controller.selectedRank,
                      items: PersonnelLookup.ranks,
                      hint: "Rütbe",
                      onChanged: controller.setRank,
                    ),

                    PGYSDropdownField<String>(
                      value: controller.selectedDepartment,
                      items: PersonnelLookup.department,
                      hint: "Şube",
                      onChanged: controller.setDepartment,
                    ),

                    PGYSDropdownField<String>(
                      value: controller.selectedBranch,
                      items: PersonnelLookup.branches,
                      hint: "Büro",
                      onChanged: controller.setBranch,
                    ),

                    PGYSTextField(label: "Ünvan"),
                  ],
                ),
              ],
            ),
            PGYSFormActions(
              saveEnabled: controller.isValid,
              onCancel: () {
                Navigator.pop(context);
              },

              onSave: () async {
                if (!controller.isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen zorunlu alanları doldurun."),
                    ),
                  );
                  return;
                }
                await addPersonnel(controller.buildPersonnel());
                ref.invalidate(personnelListProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Personel başarıyla eklendi")),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
