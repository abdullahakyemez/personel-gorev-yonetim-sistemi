import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_icon_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_search_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/keyboard/pgys_keyboard_shortcuts.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/loading/pgys_table_loading.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_toolbar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/controllers/personnel_table_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import 'personnel_selection_toolbar.dart';
import 'personnel_table_header.dart';
import 'personnel_table_row.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_count_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';

class PersonnelTable extends ConsumerStatefulWidget {
  const PersonnelTable({super.key});

  @override
  ConsumerState<PersonnelTable> createState() => _PersonnelTableState();
}

class _PersonnelTableState extends ConsumerState<PersonnelTable> {
  late final TextEditingController searchController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = ref.watch(selectedPersonnelCountProvider);
    final personnelAsync = ref.watch(filteredPersonnelProvider);
    final canCreatePersonnel = ref.watch(hasPermissionProvider(AppPermission.createPersonnel));
    final canExportReports = ref.watch(hasPermissionProvider(AppPermission.exportReports));
    final controller = PersonnelTableController(ref: ref, context: context);

    return PGYSKeyboardShortcuts(
      onSelectAll: controller.selectAll,
      onEscape: controller.escape,
      onDelete: controller.delete,
      onArrowUp: () {
        controller.arrowUp(scrollController);
      },
      onArrowDown: () {
        controller.arrowDown(scrollController);
      },
      onEnter: () => controller.enter(context),
      onHome: () {
        controller.home(scrollController);
      },
      onEnd: () {
        controller.end(scrollController);
      },
      child: personnelAsync.when(
        data: (personnelList) {
          final infoText = selectedCount == 0
              ? "Toplam Personel : ${personnelList.length}"
              : "";
          final toolbarWidget = AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -0.15),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: selectedCount == 0
                ? PGYSTableToolbar(
                    key: const ValueKey("normalToolbar"),
                    filters: [
                      SizedBox(
                        width: 300,
                        child: PGYSSearchField(
                          controller: searchController,
                          hintText: "Personel Ara...",
                          onChanged: (value) {
                            ref.read(personnelSearchProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 170,
                        child: PGYSDropdownField<String>(
                          value: ref.watch(selectedRankProvider),
                          hint: "Rütbe",
                          items: PersonnelLookup.ranks,
                          onChanged: (value) {
                            ref.read(selectedRankProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 200,
                        child: PGYSDropdownField<String>(
                          value: ref.watch(selectedBranchProvider),
                          hint: "Büro",
                          items: PersonnelLookup.branches,
                          onChanged: (value) {
                            ref.read(selectedBranchProvider.notifier).state =
                                value;
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
                      if (canExportReports) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00875A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.file_download_outlined, size: 18),
                          label: const Text(
                            "Excel Aktar",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final allPersonnel =
                                  await ref.read(personnelListProvider.future);
                              final path = await PersonnelExcelExportService().export(
                                personnel: allPersonnel,
                              );
                              if (!context.mounted || path == null) return;
                              PGYSFeedback.showSuccess(
                                context,
                                'Tüm personel Excel dosyası kaydedildi: $path',
                              );
                            } catch (error) {
                              if (!context.mounted) return;
                              PGYSFeedback.showError(
                                context,
                                'Excel aktarımı başarısız: $error',
                              );
                            }
                          },
                        ),
                      ],
                      if (canCreatePersonnel) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F2027),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text(
                            "Personel Ekle",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () {
                            showAddPersonnelDialog(context);
                          },
                        ),
                      ],
                    ],
                  )
                : const PersonnelSelectionToolbar(
                    key: ValueKey("selectionToolbar"),
                  ),
          );

          return Column(
            children: [
              toolbarWidget,
              const SizedBox(height: 12),
              Expanded(
                child: PGYSTable(
                  scrollController: scrollController,
                  toolbar: null,
            infoBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    infoText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            header: const PersonnelTableHeader(),

            rows: List.generate(personnelList.length, (index) {
              return PersonnelTableRow(
                //key: ValueKey("${personnelList[index].id}_${index}"),
                personnel: personnelList[index],
                index: index,
                onEdit: () {
                  showEditPersonnelDialog(context, personnelList[index]);
                },
                onDelete: () {
                  showDeletePersonnelDialog(context, ref, personnelList[index]);
                },
                onSelect: () {
                  controller.selectPersonByMouse(personnelList[index], index);
                },
              );
            }),
          ),
        ),
      ],
    );
  },
  loading: () => const PGYSTableLoading(),
  error: (error, stackTrace) {
    return Center(child: Text("Bir hata oluştu\n$error"));
  },
),
);
  }
}
