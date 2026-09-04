import 'package:flutter_riverpod/legacy.dart';

/// Toplu işlem için seçilen satırlar yalnızca Personeller ekranı açıkken tutulur.
final selectedPersonnelIdsProvider = StateProvider.autoDispose<Set<int>>(
  (ref) => <int>{},
);
