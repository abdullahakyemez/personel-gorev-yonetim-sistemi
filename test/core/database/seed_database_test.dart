import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/seed_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/password_hasher.dart';

void main() {
  group('SeedDatabase Tests', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test(
        'seed() populates admin with username admin, password admin123 and requiresPasswordChange true',
        () async {
      final seeder = SeedDatabase(database);
      await seeder.seed();

      final user = await (database.select(database.userTable)
            ..where((tbl) => tbl.username.equals('admin')))
          .getSingleOrNull();

      expect(user, isNotNull);
      expect(user!.username, equals('admin'));
      expect(user.fullName, equals('Sistem Yöneticisi'));
      expect(user.role, equals(UserRole.admin.name));
      expect(user.requiresPasswordChange, isTrue);
      expect(user.isActive, isTrue);

      // Password hash verification for admin123
      final isPasswordValid =
          PasswordHasher.verifyPassword('admin123', user.salt, user.passwordHash);
      expect(isPasswordValid, isTrue);
    });

    test(
        'seed() preserves existing admin user password and does not overwrite it',
        () async {
      // First insert user with existing custom password
      final customSalt = PasswordHasher.generateSalt();
      final customHash = PasswordHasher.hashPassword('OzelSifre.123', customSalt);

      await database.into(database.userTable).insert(
        UserTableCompanion.insert(
          username: 'admin',
          passwordHash: customHash,
          salt: customSalt,
          fullName: 'Sistem Yöneticisi',
          role: UserRole.admin.name,
        ),
      );

      // Run seeder
      final seeder = SeedDatabase(database);
      await seeder.seed();

      // Check user
      final user = await (database.select(database.userTable)
            ..where((tbl) => tbl.username.equals('admin')))
          .getSingle();

      expect(user.username, equals('admin'));

      // Password should remain the custom password, NOT overwritten by admin123
      final isCustomPasswordValid =
          PasswordHasher.verifyPassword('OzelSifre.123', user.salt, user.passwordHash);
      expect(isCustomPasswordValid, isTrue);

      final isDefaultPasswordValid =
          PasswordHasher.verifyPassword('admin123', user.salt, user.passwordHash);
      expect(isDefaultPasswordValid, isFalse);
    });
  });
}
