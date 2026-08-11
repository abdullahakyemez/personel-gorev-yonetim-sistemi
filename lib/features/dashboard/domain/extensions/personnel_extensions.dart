import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

extension PersonnelListExtension on List<Personnel> {
  Map<String, Personnel> get byRegistry {
    return {for (final p in this) p.registryNumber: p};
  }
}
