import '../../../domain/models/personnel.dart';
import '../../../domain/repositories/personnel_repository.dart';
import 'personnel_mock_datasource.dart';

class MockPersonnelRepository implements PersonnelRepository {
  final PersonnelMockDatasource datasource;

  MockPersonnelRepository(this.datasource);

  @override
  Future<List<Personnel>> getAllPersonnel() async {
    return datasource.getAllPersonnel();
  }

  @override
  Future<void> addPersonnel(Personnel personnel) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePersonnel(Personnel personnel) async {
    throw UnimplementedError("Mock updatepersonnel henüz uygulanmadı");
  }

  @override
  Future<void> deletePersonnel(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Personnel?> getPersonnelById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteManyPersonnel(List<int> ids) async {
    throw UnimplementedError();
  }
}
