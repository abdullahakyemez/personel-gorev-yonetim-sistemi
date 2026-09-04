import 'package:flutter_riverpod/legacy.dart';

enum PersonnelDetailTab { general, tasks, leaves, history }

/// Detay panelinde seçili sekme sadece Personeller ekranı açıkken yaşar.
final selectedPersonnelTabProvider = StateProvider.autoDispose<PersonnelDetailTab>(
  (ref) => PersonnelDetailTab.general,
);
