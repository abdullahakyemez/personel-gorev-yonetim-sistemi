import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';

import '../../../application/selected_personnel_ids_provider.dart';

class PersonnelSelectionToolbar extends ConsumerWidget {
  const PersonnelSelectionToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedPersonnelIdsProvider);
    //final deleteManyPersonnel = getIt<DeleteManyPersonnelUseCase>();

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20),
          const SizedBox(width: 8),
          Text(
            "${selected.length} Personel Seçildi",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),

          FilledButton.icon(
            onPressed: selected.isEmpty
                ? null
                : () async {
                    showDeleteManyPersonnelDialog(context, ref);
                  },
            icon: const Icon(Icons.delete_outline),
            label: const Text("Sil"),
          ),

          const SizedBox(width: 8),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.assignment_outlined),
            label: const Text("Görev Ata"),
          ),

          const SizedBox(width: 8),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
            label: const Text("Excel"),
          ),

          const SizedBox(width: 8),

          TextButton.icon(
            onPressed: () {
              ref.read(selectedPersonnelIdsProvider.notifier).state = {};
            },
            icon: const Icon(Icons.close),
            label: const Text("Vazgeç"),
          ),
        ],
      ),
    );
  }
}
