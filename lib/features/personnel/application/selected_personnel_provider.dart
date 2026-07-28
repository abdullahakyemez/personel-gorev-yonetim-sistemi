import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import '../domain/models/personnel.dart';

final selectedPersonnelIdProvider = StateProvider<int?>((ref) => null);
final selectedPersonnelProvider = Provider<Personnel?>((ref) {
  final id = ref.watch(selectedPersonnelIdProvider);

  final personnel = ref.watch(personnelListProvider);

  return personnel.whenData((list) {
    if (id == null) return null;

    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }).value;
});
