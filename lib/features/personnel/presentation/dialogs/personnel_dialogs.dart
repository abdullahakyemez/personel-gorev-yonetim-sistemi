import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_ids_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/delete_many_personnel_usecase.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/delete_personnel_usecase.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

Future<void> showAddPersonnelDialog(BuildContext context) async {
  final controller = PersonFormController();

  await showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Yeni Personel",
      child: PersonForm(controller: controller),
    ),
  );

  controller.dispose();
}

Future<void> showEditPersonnelDialog(
  BuildContext context,
  Personnel person,
) async {
  final controller = PersonFormController();

  await showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Personel Düzenle",
      child: PersonForm(controller: controller, personnel: person),
    ),
  );

  controller.dispose();
}

Future<void> showDeletePersonnelDialog(
  BuildContext context,
  WidgetRef ref,
  Personnel person,
) async {
  final deletePersonnel = getIt<DeletePersonnelUseCase>();

  await showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Personel Sil",
      scrollable: false,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Vazgeç"),
        ),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: AppColors.background,
          ),
          onPressed: () async {
            await deletePersonnel(person.id!);
            ref.invalidate(personnelListProvider);
            ref.read(selectedPersonnelIdProvider.notifier).state = null;
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Personel Silindi")));
            }
          },
          icon: const Icon(Icons.delete),

          label: const Text("Sil"),
        ),
      ],

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
              size: 56,
            ),

            const SizedBox(height: 20),

            Text(
              "${person.fullName} isimli personel silinsin mi?",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Bu işlem geri alınamaz.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showDeleteManyPersonnelDialog(
  BuildContext context,
  WidgetRef ref,
) {
  final ids = ref.read(selectedPersonnelIdsProvider);
  final deleteManyPersonnel = getIt<DeleteManyPersonnelUseCase>();

  return showDialog(
    context: context,
    builder: (_) => PGYSDialog(
      title: "Toplu Personel Sil",
      scrollable: false,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Vazgeç"),
        ),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: AppColors.background,
          ),
          onPressed: () async {
            await deleteManyPersonnel(ids.toList());
            ref.invalidate(personnelListProvider);
            ref.invalidate(selectedPersonnelProvider);
            ref.read(selectedPersonnelIdsProvider.notifier).state = {};
            ref.read(selectedPersonnelIdProvider.notifier).state = null;
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${ids.length} personel silindi.")),
              );
            }
          },
          icon: const Icon(Icons.delete),

          label: const Text("Sil"),
        ),
      ],

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
              size: 56,
            ),

            const SizedBox(height: 20),

            Text(
              "Seçili ${ids.length} personel kalıcı olarak silinecek.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Bu işlem geri alınamaz.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}
