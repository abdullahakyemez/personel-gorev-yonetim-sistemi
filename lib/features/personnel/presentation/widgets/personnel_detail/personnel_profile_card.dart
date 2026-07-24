import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

class PersonnelProfileCard extends StatelessWidget {
  final Personnel person;

  const PersonnelProfileCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        SizedBox(height: 16),
        Text(
          person.fullName,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(person.rank, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () {
                final controller = PersonFormController();
                controller.load(person);
                showDialog(
                  context: context,
                  builder: (_) => PGYSDialog(
                    title: "Personel Düzenle",
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Kapat"),
                      ),
                    ],
                    child: PersonForm(controller: controller),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Düzenle"),
            ),
          ],
        ),
      ],
    );
  }
}
