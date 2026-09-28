import '../../models/personnel.dart';
import '../../models/personnel_import_result.dart';
import '../../repositories/personnel_repository.dart';

class ImportPersonnelUseCase {
  final PersonnelRepository repository;

  ImportPersonnelUseCase(this.repository);

  Future<PersonnelImportResult> call({
    required List<Personnel> personnelList,
    required bool overwriteExisting,
  }) {
    return repository.importPersonnelList(
      personnelList: personnelList,
      overwriteExisting: overwriteExisting,
    );
  }
}
