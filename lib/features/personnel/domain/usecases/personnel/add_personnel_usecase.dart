import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_repository.dart';

class AddPersonnelUseCase {
  final PersonnelRepository repository;

  AddPersonnelUseCase(this.repository);

  Future<void> call(Personnel personnel) {
    return repository.addPersonnel(personnel);
  }
}
