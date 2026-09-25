import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/keyboard/pgys_keyboard_shortcuts.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/loading/pgys_table_loading.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/controllers/personnel_table_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import '../personnel_filter_bar.dart';
import 'personnel_selection_toolbar.dart';
import 'personnel_table_header.dart';
import 'personnel_table_row.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_count_provider.dart';

class PersonnelTable extends ConsumerStatefulWidget {
  const PersonnelTable({super.key});

  @override
  ConsumerState<PersonnelTable> createState() => _PersonnelTableState();
}

class _PersonnelTableState extends ConsumerState<PersonnelTable> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = ref.watch(selectedPersonnelCountProvider);
    final personnelAsync = ref.watch(filteredPersonnelProvider);
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
                ? const PersonnelFilterBar(
                    key: ValueKey("normalToolbar"),
                  )
                : const PersonnelSelectionToolbar(
                    key: ValueKey("selectionToolbar"),
                  ),
          );

          return Column(
            children: [
              toolbarWidget,
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 16, 6),
                child: Row(
                  children: [
                    Text(
                      '${personnelList.length} personel listeleniyor',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (selectedCount > 0) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$selectedCount seçili',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: PGYSTable(
                  scrollController: scrollController,
                  toolbar: null,
                  infoBar: null,
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
                        showDeletePersonnelDialog(
                          context,
                          ref,
                          personnelList[index],
                        );
                      },
                      onSelect: () {
                        controller.selectPersonByMouse(
                          personnelList[index],
                          index,
                        );
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
