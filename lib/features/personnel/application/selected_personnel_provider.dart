import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import '../domain/models/personnel.dart';

/// Personeller ekranına ait geçici detay seçimi.
///
/// Ekrandan çıkıldığında provider dinleyicisini kaybettiği için otomatik olarak
/// dispose edilir. Böylece Personeller ekranına yeniden dönüldüğünde herhangi
/// bir personel seçili gelmez ve tablo tam genişlikte açılır.
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
