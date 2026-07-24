import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_primary_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_search_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/loading/pgys_table_loading.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_toolbar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/datasource/mock/personnel_filter_data.dart';

import 'personnel_table_header.dart';
import 'personnel_table_row.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table.dart';

class PersonnelTable extends ConsumerStatefulWidget {
  const PersonnelTable({super.key});

  @override
  ConsumerState<PersonnelTable> createState() => _PersonnelTableState();
}

class _PersonnelTableState extends ConsumerState<PersonnelTable> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(filteredPersonnelProvider);
    return personnelAsync.when(
      data: (personnelList) {
        return PGYSTable(
          toolbar: PGYSTableToolbar(
            leading: PGYSSearchField(
              controller: searchController,
              hintText: "Personel Ara...",
              onChanged: (value) {
                ref.read(personnelSearchProvider.notifier).state = value;
              },
            ),

            actions: [
              PGYSDropdownField<String?>(
                value: ref.watch(selectedRankProvider),
                hint: "Rütbe",
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text("Tümü"),
                  ),
                  ...personnelRanks.map(
                    (rank) => DropdownMenuItem<String?>(
                      value: rank,
                      child: Text(rank),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(selectedRankProvider.notifier).state = value;
                },
              ),
              PGYSDropdownField<String?>(
                value: ref.watch(selectedBranchProvider),
                hint: "Büro",
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text("Tümü"),
                  ),
                  ...personnelBranches.map(
                    (branch) => DropdownMenuItem<String?>(
                      value: branch,
                      child: Text(branch),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(selectedBranchProvider.notifier).state = value;
                },
              ),
              OutlinedButton.icon(
                onPressed: () {
                  searchController.clear();
                  ref.read(personnelSearchProvider.notifier).state = "";
                  ref.read(selectedRankProvider.notifier).state = null;
                  ref.read(selectedBranchProvider.notifier).state = null;
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Temizle"),
              ),
              PGYSPrimaryButton(
                text: "Personel Ekle",
                icon: Icons.add,
                onPressed: () {},
              ),
            ],
          ),
          infoBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text(
                  "Toplam Personel : ${personnelList.length}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          header: const PersonnelTableHeader(),
          rows: List.generate(personnelList.length, (index) {
            return PersonnelTableRow(
              personnel: personnelList[index],
              index: index,
            );
          }),
        );
      },
      loading: () => const PGYSTableLoading(),
      error: (error, stackTrace) {
        return Center(child: Text("Bir hata oluştu\n$error"));
      },
    );
  }
}
