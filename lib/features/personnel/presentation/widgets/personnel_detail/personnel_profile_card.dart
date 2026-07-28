import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';

class PersonnelProfileCard extends ConsumerWidget {
  final Personnel person;

  const PersonnelProfileCard({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            SizedBox(
              width: 120,
              child: FilledButton.icon(
                onPressed: () {
                  showEditPersonnelDialog(context, person);
                },
                icon: const Icon(Icons.edit),
                label: const Text("Düzenle"),
              ),
            ),
            SizedBox(width: 8),

            SizedBox(
              width: 120,

              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: AppColors.background,
                ),

                onPressed: () {
                  showDeletePersonnelDialog(context, ref, person);
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text("Sil"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
