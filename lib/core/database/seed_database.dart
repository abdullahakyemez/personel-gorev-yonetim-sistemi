import 'package:drift/drift.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/password_hasher.dart';

import 'app_database.dart';

class SeedDatabase {
  final AppDatabase database;

  SeedDatabase(this.database);

  /// İlk kurulumda sadece zorunlu şifre değişimine tabi tutulan
  /// varsayılan kurumsal sistem yöneticisi (admin) hesabını oluşturur.
  Future<void> seed() async {
    await _seedDefaultAdmin();
  }

  Future<void> _seedDefaultAdmin() async {
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
          requiresPasswordChange: const Value(true),
          isActive: const Value(true),
        ),
      );
    }
  }
}


