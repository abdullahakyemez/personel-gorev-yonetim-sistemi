import 'package:flutter_riverpod/legacy.dart';

/// Klavye ile gezilen aktif satır
final currentPersonnelIndexProvider = StateProvider<int?>((ref) => null);

/// Shift seçim başlangıcı
final selectionAnchorProvider = StateProvider<int?>((ref) => null);
