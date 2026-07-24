import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_repository.dart';

class GetAllPersonnelUseCase {
  final PersonnelRepository repository;

  GetAllPersonnelUseCase(this.repository);

  Future<List<Personnel>> call() {
    return repository.getAllPersonnel();
  }
}
