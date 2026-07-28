import '../../repositories/personnel_repository.dart';

class DeletePersonnelUseCase {
  final PersonnelRepository repository;

  DeletePersonnelUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deletePersonnel(id);
  }
}
