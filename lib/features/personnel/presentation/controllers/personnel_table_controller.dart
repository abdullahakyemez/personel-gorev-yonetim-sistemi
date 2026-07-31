import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/keyboard_state_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_ids_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_selection_provider.dart';

class PersonnelTableController {
  final WidgetRef ref;
  final BuildContext context;

  PersonnelTableController({required this.ref, required this.context});

  List<Personnel> get personnel =>
      ref.read(filteredPersonnelProvider).value ?? [];

  StateController<int?> get selectedIdNotifier =>
      ref.read(selectedPersonnelIdProvider.notifier);

  void selectAll() {
    personnel;

    final notifier = ref.read(selectedPersonnelIdsProvider.notifier);

    final current = notifier.state;

    final allIds = personnel
        .where((e) => e.id != null)
        .map((e) => e.id!)
        .toSet();

    if (current.length == allIds.length) {
      notifier.state = {};
    } else {
      notifier.state = allIds;
    }
  }

  void escape() {
    ref.read(selectedPersonnelIdsProvider.notifier).state = {};
  }

  void delete() {
    final selected = ref.read(selectedPersonnelIdsProvider);
    if (selected.isEmpty) return;
    showDeleteManyPersonnelDialog(context, ref);
  }

  void _scrollToIndex(ScrollController controller, int index) {
    if (!controller.hasClients) return;
    const rowHeight = 56.0;

    final rowTop = index * rowHeight;
    final rowBottom = rowTop + rowHeight;

    final visibleTop = controller.offset;
    final visibleBottom = visibleTop + controller.position.viewportDimension;

    // Satır görünür alanın üstünde kaldıysa
    if (rowTop < visibleTop) {
      controller.animateTo(
        rowTop,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
      return;
    }

    // Satır görünür alanın altında kaldıysa
    if (rowBottom > visibleBottom) {
      controller.animateTo(
        rowBottom - controller.position.viewportDimension,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  void setCurrentSelection(Personnel person, int index) {
    ref.read(currentPersonnelIndexProvider.notifier).state = index;
    selectedIdNotifier.state = person.id;
  }

  void setAnchor(int index) {
    ref.read(selectionAnchorProvider.notifier).state = index;
  }

  void selectPersonByMouse(Personnel person, int index) {
    setAnchor(index);
    setCurrentSelection(person, index);
    ref.read(selectedPersonnelIdsProvider.notifier).state = {};
  }

  void moveSelection(int delta, ScrollController controller) {
    if (personnel.isEmpty) return;
    final current = ref.read(currentPersonnelIndexProvider);

    // İlk seçim yoksa
    if (current == null) {
      moveToIndex(0, controller);
      return;
    }

    moveToIndex(current + delta, controller);
  }

  /*void moveTo(int index, ScrollController controller) {
    if (personnel.isEmpty) return;

    currentIndex = index;

    final person = personnel[index];

    if (ref.read(shiftPressedProvider)) {
      setCurrentSelection(person, index);
      updateShiftSelection(index);
    } else {
      setAnchor(index);
      setCurrentSelection(person, index);

      ref.read(selectedPersonnelIdsProvider.notifier).state = {};
    }

    _scrollToIndex(controller, index);
  }*/

  void arrowUp(ScrollController controller) {
    moveSelection(-1, controller);
  }

  void arrowDown(ScrollController controller) {
    moveSelection(1, controller);
  }

  void enter(BuildContext context) {
    final selected = ref.read(selectedPersonnelProvider);

    if (selected == null) return;
    showEditPersonnelDialog(context, selected);
  }

  void home(ScrollController controller) {
    moveToIndex(0, controller);
  }

  void end(ScrollController controller) {
    moveToIndex(personnel.length - 1, controller);
  }

  void updateShiftSelection(int currentIndex) {
    final anchor = ref.read(selectionAnchorProvider);
    if (anchor == null) return;

    final start = anchor;
    final end = currentIndex;

    final from = start < end ? start : end;
    final to = start > end ? start : end;

    final ids = personnel
        .sublist(from, to + 1)
        .where((e) => e.id != null)
        .map((e) => e.id!)
        .toSet();

    ref.read(selectedPersonnelIdsProvider.notifier).state = ids;
  }

  void moveToIndex(int index, ScrollController controller) {
    if (personnel.isEmpty) return;

    final safeIndex = index.clamp(0, personnel.length - 1);

    final person = personnel[safeIndex];

    if (ref.read(shiftPressedProvider)) {
      setCurrentSelection(person, safeIndex);
      updateShiftSelection(safeIndex);
    } else {
      setAnchor(safeIndex);
      setCurrentSelection(person, safeIndex);

      ref.read(selectedPersonnelIdsProvider.notifier).state = {};
    }

    _scrollToIndex(controller, safeIndex);
  }
}
