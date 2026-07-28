import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_cell.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_status_badge.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';

class PersonnelTableRow extends ConsumerWidget {
  final Personnel personnel;
  final int index;

  const PersonnelTableRow({
    super.key,
    required this.personnel,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPerson = ref.watch(selectedPersonnelProvider);
    final isSelected = selectedPerson?.id == personnel.id;
    return PGYSTableRow(
      selected: isSelected,
      index: index,
      onTap: () {
        ref.read(selectedPersonnelIdProvider.notifier).state = personnel.id;
      },
      children: [
        PGYSTableCell(child: Text(personnel.registryNumber)),

        PGYSTableCell(flex: 2, child: Text(personnel.fullName)),

        PGYSTableCell(child: Text(personnel.rank)),

        PGYSTableCell(flex: 2, child: Text(personnel.branch)),

        PGYSTableCell(child: Text(personnel.phone)),

        PGYSTableCell(
          child: Align(
            alignment: Alignment.centerLeft,
            child: PGYSStatusBadge(onDuty: personnel.onDuty),
          ),
        ),

        PGYSTableCell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showEditPersonnelDialog(context, personnel);
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: "Düzenle",
              ),
              IconButton(
                onPressed: () {
                  showDeletePersonnelDialog(context, ref, personnel);
                },
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: "Sil",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
