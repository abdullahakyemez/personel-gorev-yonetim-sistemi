import '../../repositories/personnel_repository.dart';

class DeleteManyPersonnelUseCase {
  final PersonnelRepository repository;

  DeleteManyPersonnelUseCase(this.repository);

  Future<void> call(List<int> ids) {
    return repository.deleteManyPersonnel(ids);
  }
}
