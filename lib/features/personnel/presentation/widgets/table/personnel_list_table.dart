import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_icon_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_primary_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/inputs/pgys_search_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/loading/pgys_table_loading.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_toolbar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';

import 'personnel_table_header.dart';
import 'personnel_table_row.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

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
            filters: [
              SizedBox(
                width: 320,
                child: PGYSSearchField(
                  controller: searchController,
                  hintText: "Personel Ara...",
                  onChanged: (value) {
                    ref.read(personnelSearchProvider.notifier).state = value;
                  },
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 170,
                child: PGYSDropdownField<String>(
                  value: ref.watch(selectedRankProvider),
                  hint: "Rütbe",
                  items: PersonnelLookup.ranks,
                  onChanged: (value) {
                    ref.read(selectedRankProvider.notifier).state = value;
                  },
                ),
              ),
              SizedBox(width: 12),

              SizedBox(
                width: 220,
                child: PGYSDropdownField<String>(
                  value: ref.watch(selectedBranchProvider),
                  hint: "Büro",
                  items: PersonnelLookup.branches,
                  onChanged: (value) {
                    ref.read(selectedBranchProvider.notifier).state = value;
                  },
                ),
              ),
            ],

            actions: [
              PGYSIconButton(
                onPressed: () {
                  searchController.clear();
                  ref.read(personnelSearchProvider.notifier).state = "";
                  ref.read(selectedRankProvider.notifier).state = null;
                  ref.read(selectedBranchProvider.notifier).state = null;
                },
                icon: Icons.filter_alt_off_outlined,
                size: AppSpacing.xl,
                tooltip: "Filtreleri temizle",
              ),
              SizedBox(width: 8),
              PGYSPrimaryButton(
                text: "Personel Ekle",
                icon: Icons.add,
                onPressed: () {
                  final controller = PersonFormController();

                  showDialog(
                    context: context,
                    builder: (_) {
                      return PGYSDialog(
                        title: "Yeni Personel",
                        child: PersonForm(controller: controller),
                      );
                    },
                  );
                },
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
