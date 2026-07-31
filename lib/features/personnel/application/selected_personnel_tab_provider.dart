import 'package:flutter_riverpod/legacy.dart';

enum PersonnelDetailTab { general, tasks, leaves, history }

final selectedPersonnelTabProvider = StateProvider<PersonnelDetailTab>(
  (ref) => PersonnelDetailTab.general,
);
