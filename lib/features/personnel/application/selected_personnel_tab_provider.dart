import 'package:flutter_riverpod/legacy.dart';

enum PersonnelDetailTab { general, tasks, leaves, documents, discipline }

final selectedPersonnelTabProvider = StateProvider<PersonnelDetailTab>(
  (ref) => PersonnelDetailTab.general,
);
