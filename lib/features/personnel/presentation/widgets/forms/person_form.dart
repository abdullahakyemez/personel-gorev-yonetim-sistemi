import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_section.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_actions.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/update_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/add_personnel_usecase.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

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
        widget.controller.fullNameFocus.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addPersonnel = getIt<AddPersonnelUseCase>();
    final updatePersonnel = getIt<UpdatePersonnelUseCase>();
    final isEdit = widget.personnel != null;

    return AnimatedBuilder(
      animation: widget.controller,
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
                      controller: widget.controller.fullNameController,
                      focusNode: widget.controller.fullNameFocus,
                      nextFocusNode: widget.controller.registryFocus,
                    ),
                    PGYSTextField(
                      label: "Sicil",
                      controller: widget.controller.registryController,
                      keyboardType: TextInputType.number,
                      focusNode: widget.controller.registryFocus,
                      nextFocusNode: widget.controller.phoneFocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    PGYSTextField(
                      label: "Telefon",
                      controller: widget.controller.phoneController,
                      keyboardType: TextInputType.phone,
                      focusNode: widget.controller.phoneFocus,
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
                      value: widget.controller.selectedRank,
                      items: PersonnelLookup.ranks,
                      hint: "Rütbe",
                      onChanged: widget.controller.setRank,
                    ),

                    PGYSDropdownField<String>(
                      value: widget.controller.selectedDepartment,
                      items: PersonnelLookup.department,
                      hint: "Şube",
                      onChanged: widget.controller.setDepartment,
                    ),

                    PGYSDropdownField<String>(
                      value: widget.controller.selectedBranch,
                      items: PersonnelLookup.branches,
                      hint: "Büro",
                      onChanged: widget.controller.setBranch,
                    ),

                    PGYSTextField(label: "Ünvan"),
                  ],
                ),
              ],
            ),
            PGYSFormActions(
              saveText: isEdit ? "Güncelle" : "Kaydet",
              saveEnabled: widget.controller.isValid,
              onCancel: () {
                Navigator.pop(context);
              },

              onSave: () async {
                if (!widget.controller.isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen zorunlu alanları doldurun."),
                    ),
                  );
                  return;
                }
                if (widget.personnel == null) {
                  await addPersonnel(widget.controller.buildPersonnel());
                  ref.invalidate(personnelListProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Personel başarıyla eklendi."),
                      ),
                    );
                  }
                } else {
                  await updatePersonnel(
                    widget.controller.buildPersonnel(id: widget.personnel?.id),
                  );

                  ref.invalidate(personnelListProvider);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Personel başarıyla güncellendi"),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
