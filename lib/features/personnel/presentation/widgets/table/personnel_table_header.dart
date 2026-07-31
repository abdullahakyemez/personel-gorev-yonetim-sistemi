import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_header.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_header_cell.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_sort_provider.dart';
import '../../../application/personnel_provider.dart';
import '../../../application/selected_personnel_ids_provider.dart';

class PersonnelTableHeader extends ConsumerWidget {
  const PersonnelTableHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnel = ref.watch(filteredPersonnelProvider);
    final selected = ref.watch(selectedPersonnelIdsProvider);
    final sort = ref.watch(personnelSortProvider);
    IconData iconFor(PersonnelSortField field) {
      if (sort.field != field) {
        return Icons.unfold_more;
      }

      return sort.direction == SortDirection.ascending
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down;
    }

    return personnel.when(
      data: (list) {
        final allIds = list.map((e) => e.id!).toSet();

        final allSelected =
            selected.length == allIds.length && allIds.isNotEmpty;

        final partiallySelected = selected.isNotEmpty && !allSelected;
        return PGYSTableHeader(
          children: [
            SizedBox(
              width: 48,
              child: Checkbox(
                tristate: true,

                value: allSelected
                    ? true
                    : partiallySelected
                    ? null
                    : false,

                onChanged: (value) {
                  final notifier = ref.read(
                    selectedPersonnelIdsProvider.notifier,
                  );

                  if (value == true) {
                    notifier.state = allIds;
                  } else {
                    notifier.state = {};
                  }
                },
              ),
            ),
            PGYSTableHeaderCell(
              title: "Sicil",
              sortable: true,
              sortIcon: iconFor(PersonnelSortField.registry),
              onSort: () {
                ref
                    .read(personnelSortProvider.notifier)
                    .toggle(PersonnelSortField.registry);
              },
            ),

            PGYSTableHeaderCell(
              title: "Ad Soyad",
              flex: 2,
              sortable: true,
              onSort: () {
                ref
                    .read(personnelSortProvider.notifier)
                    .toggle(PersonnelSortField.fullName);
              },
              sortIcon: iconFor(PersonnelSortField.fullName),
            ),

            PGYSTableHeaderCell(
              title: "Rütbe",
              sortable: true,
              onSort: () {
                ref
                    .read(personnelSortProvider.notifier)
                    .toggle(PersonnelSortField.rank);
              },
              sortIcon: iconFor(PersonnelSortField.rank),
            ),

            PGYSTableHeaderCell(
              title: "Büro",
              flex: 2,
              sortable: true,
              onSort: () {
                ref
                    .read(personnelSortProvider.notifier)
                    .toggle(PersonnelSortField.branch);
              },
              sortIcon: iconFor(PersonnelSortField.branch),
            ),

            PGYSTableHeaderCell(title: "Telefon"),

            PGYSTableHeaderCell(title: "Durum"),

            PGYSTableHeaderCell(title: "İşlemler"),
          ],
        );
      },
      error: (_, _) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}
