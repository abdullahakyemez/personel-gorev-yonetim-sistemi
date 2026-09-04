import 'package:flutter_riverpod/legacy.dart';

/// Klavye ile gezilen aktif satır.
/// Personeller ekranından çıkıldığında seçim bilgisi temizlenir.
final currentPersonnelIndexProvider = StateProvider.autoDispose<int?>((ref) => null);

/// Shift seçim başlangıcı.
/// Personeller ekranından çıkıldığında seçim bilgisi temizlenir.
final selectionAnchorProvider = StateProvider.autoDispose<int?>((ref) => null);
