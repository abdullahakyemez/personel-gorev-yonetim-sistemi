import '../../models/personnel.dart';
import '../../repositories/personnel_repository.dart';

class UpdatePersonnelUseCase {
  final PersonnelRepository repository;

  UpdatePersonnelUseCase(this.repository);

  Future<void> call(Personnel personnel) {
    return repository.updatePersonnel(personnel);
  }
}
