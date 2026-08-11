import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/context_menu/context_menu_helper.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/context_menu/pgys_context_menu.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/context_menu/pgys_context_menu_action.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/context_menu/pgys_context_menu_item.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_cell.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_status_badge.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_ids_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';

class PersonnelTableRow extends ConsumerWidget {
  final Personnel personnel;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;

  const PersonnelTableRow({
    super.key,
    required this.personnel,
    required this.index,
    this.onEdit,
    this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleMenu(PGYSContextMenuAction action) {
      switch (action) {
        case PGYSContextMenuAction.edit:
          onEdit?.call();
          break;

        case PGYSContextMenuAction.delete:
          onDelete?.call();
          break;

        default:
          break;
      }
    }

    final selectedIds = ref.watch(selectedPersonnelIdsProvider);
    final leavesAsync = ref.watch(leaveControllerProvider);
    final checked = selectedIds.contains(personnel.id);
    final selectedPerson = ref.watch(selectedPersonnelProvider);
    final isSelected = selectedPerson?.id == personnel.id;
    final menuItems = <PopupMenuEntry<PGYSContextMenuAction>>[
      PGYSContextMenuItem(
        icon: Icons.edit,
        title: "Düzenle",
        value: PGYSContextMenuAction.edit,
      ),
      PGYSContextMenuItem(
        icon: Icons.delete_outline,
        title: "Sil",
        value: PGYSContextMenuAction.delete,
      ),
    ];

    final currentStatus = leavesAsync.when(
      data: (leaves) =>
          PersonnelStatusResolver.resolve(personnel: personnel, leaves: leaves),
      loading: () => personnel.status,
      error: (_, _) => personnel.status,
    );

    return PGYSTableRow(
      selected: isSelected,
      showCheckbox: true,
      checked: checked,
      index: index,
      onTap: () {
        onSelect?.call();
      },
      onDoubleTap: () {
        showEditPersonnelDialog(context, personnel);
      },
      onCheckedChanged: (value) {
        final notifier = ref.read(selectedPersonnelIdsProvider.notifier);
        final current = {...notifier.state};

        if (value == true) {
          current.add(personnel.id!);
        } else {
          current.remove(personnel.id);
        }
        notifier.state = current;
      },
      onSecondaryTapDown: (details) async {
        final action = await showPGYSContextMenu<PGYSContextMenuAction>(
          context: context,
          details: details,
          items: menuItems,
        );

        if (action != null) {
          handleMenu(action);
        }
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
            child: PGYSStatusBadge(status: currentStatus),
          ),
        ),

        PGYSTableCell(
          child: PGYSContextMenu<PGYSContextMenuAction>(
            items: menuItems,
            onSelected: handleMenu,
            child: IconButton(
              onPressed: null,
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ),
      ],
    );
  }
}
