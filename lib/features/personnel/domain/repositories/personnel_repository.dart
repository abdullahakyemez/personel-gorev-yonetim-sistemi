import '../models/personnel.dart';

abstract class PersonnelRepository {
  Future<List<Personnel>> getAllPersonnel();

  Future<void> addPersonnel(Personnel personnel);
  Future<void> updatePersonnel(Personnel personnel);
  Future<void> deletePersonnel(int id);
  Future<void> deleteManyPersonnel(List<int> ids);
  Future<Personnel?> getPersonnelById(int id);
}
