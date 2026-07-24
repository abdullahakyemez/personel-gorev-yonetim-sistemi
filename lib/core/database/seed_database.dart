import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/datasource/seed/seed_personnel_data.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/mapper/personnel_mapper.dart';

import 'app_database.dart';

class SeedDatabase {
  final AppDatabase database;

  SeedDatabase(this.database);

  Future<void> seed() async {
    // birazdan yazacağız
    final existing = await database.select(database.personnelTable).get();

    if (existing.isNotEmpty) {
      return;
    }

    await database.transaction(() async {
      for (final person in seedPersonnelData) {
        await database
            .into(database.personnelTable)
            .insert(person.toCompanion());
      }
    });
  }
}
