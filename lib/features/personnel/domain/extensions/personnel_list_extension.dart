import '../models/personnel.dart';

extension PersonnelListExtension on List<Personnel> {
  /// Sicil numarasına göre hızlı erişim
  Map<String, Personnel> get byRegistry {
    return {for (final p in this) p.registryNumber: p};
  }

  /// Sicilden personel bulur.
  Personnel? findByRegistry(String registryNumber) {
    try {
      return firstWhere((e) => e.registryNumber == registryNumber);
    } catch (_) {
      return null;
    }
  }

  /// Personelin tam adını döndürür.
  String getName(String registryNumber) {
    return findByRegistry(registryNumber)?.fullName ?? "-";
  }
}
