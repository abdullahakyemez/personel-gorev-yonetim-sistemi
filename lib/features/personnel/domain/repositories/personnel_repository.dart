import '../models/personnel.dart';
import '../models/personnel_import_result.dart';

abstract class PersonnelRepository {
  Future<List<Personnel>> getAllPersonnel();

  Future<void> addPersonnel(Personnel personnel);
  Future<void> updatePersonnel(Personnel personnel);
  Future<void> deletePersonnel(int id);
  Future<void> deleteManyPersonnel(List<int> ids);
  Future<Personnel?> getPersonnelById(int id);
  Future<PersonnelImportResult> importPersonnelList({
    required List<Personnel> personnelList,
    required bool overwriteExisting,
  });
}

