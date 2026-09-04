import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'selected_personnel_ids_provider.dart';

final selectedPersonnelCountProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(selectedPersonnelIdsProvider).length;
});
