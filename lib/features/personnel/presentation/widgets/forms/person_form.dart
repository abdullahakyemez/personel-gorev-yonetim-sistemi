import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_section.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_actions.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_form_grid.dart';

class PersonForm extends StatelessWidget {
  final PersonFormController controller;
  const PersonForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PGYSForm(
      children: [
        PGYSFormSection(
          title: "Genel Bilgiler",
          children: [
            PGYSFormGrid(
              children: [
                PGYSTextField(
                  label: "Ad Soyad",
                  controller: controller.fullNameController,
                ),
                PGYSTextField(
                  label: "Sicil",
                  controller: controller.registryController,
                  keyboardType: TextInputType.number,
                ),
                PGYSTextField(
                  label: "Telefon",
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
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
                PGYSDropdownField<String>(items: const [], hint: "Rütbe"),

                PGYSDropdownField<String>(items: const [], hint: "Şube"),

                PGYSDropdownField<String>(items: const [], hint: "Büro"),

                PGYSTextField(label: "Ünvan"),
              ],
            ),
          ],
        ),
        PGYSFormActions(
          onCancel: () {
            Navigator.pop(context);
          },
          onSave: () {},
        ),
      ],
    );
  }
}
