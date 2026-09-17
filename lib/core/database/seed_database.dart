import 'package:drift/drift.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/password_hasher.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/datasource/seed/seed_personnel_data.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/mapper/personnel_mapper.dart';

import 'app_database.dart';

class SeedDatabase {
  final AppDatabase database;

  SeedDatabase(this.database);

  Future<void> seed() async {
    await _seedPersonnel();
    await _seedDefaultAdmin();
  }

  Future<void> _seedPersonnel() async {
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

  Future<void> _seedDefaultAdmin() async {
    // 1. Abdullah HAKYEMEZ (Büro Amiri / Admin - Tam Yetkili)
    final existingAbdullah = await (database.select(database.userTable)
          ..where((tbl) => tbl.username.equals('430558')))
        .getSingleOrNull();

    final abdullahSalt = PasswordHasher.generateSalt();
    final abdullahPasswordHash =
        PasswordHasher.hashPassword('150613', abdullahSalt);

    if (existingAbdullah == null) {
      await database.into(database.userTable).insert(
        UserTableCompanion.insert(
          username: '430558',
          passwordHash: abdullahPasswordHash,
          salt: abdullahSalt,
          fullName: 'Abdullah HAKYEMEZ',
          role: UserRole.admin.name,
          requiresPasswordChange: const Value(false),
          isActive: const Value(true),
        ),
      );
    } else {
      // Şifreyi veya yetkiyi güncelle ki kullanıcı doğrudan 150613 ile test edebilsin
      await (database.update(database.userTable)
            ..where((tbl) => tbl.username.equals('430558')))
          .write(
        UserTableCompanion(
          fullName: const Value('Abdullah HAKYEMEZ'),
          role: Value(UserRole.admin.name),
          passwordHash: Value(abdullahPasswordHash),
          salt: Value(abdullahSalt),
          requiresPasswordChange: const Value(false),
          isActive: const Value(true),
        ),
      );
    }

    // 2. Yedek Standart Admin (Eğer userTable tamamen boşsa)
    final existingAdmin = await (database.select(database.userTable)
          ..where((tbl) => tbl.username.equals('admin')))
        .getSingleOrNull();

    if (existingAdmin == null) {
      final salt = PasswordHasher.generateSalt();
      final passwordHash = PasswordHasher.hashPassword('admin123', salt);

      await database.into(database.userTable).insert(
        UserTableCompanion.insert(
          username: 'admin',
          passwordHash: passwordHash,
          salt: salt,
          fullName: 'Sistem Yöneticisi',
          role: UserRole.admin.name,
        ),
      );
    }
  }
}


