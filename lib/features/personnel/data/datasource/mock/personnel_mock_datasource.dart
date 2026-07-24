import '../../../domain/models/personnel.dart';
import '../seed/seed_personnel_data.dart';

class PersonnelMockDatasource {
  Future<List<Personnel>> getAllPersonnel() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return seedPersonnelData;
  }
}
