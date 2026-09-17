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
        'seed() populates Abdullah HAKYEMEZ as Büro Amiri (Admin) with username 430558 and password 150613',
        () async {
      final seeder = SeedDatabase(database);
      await seeder.seed();

      final user = await (database.select(database.userTable)
            ..where((tbl) => tbl.username.equals('430558')))
          .getSingleOrNull();

      expect(user, isNotNull);
      expect(user!.username, equals('430558'));
      expect(user.fullName, equals('Abdullah HAKYEMEZ'));
      expect(user.role, equals(UserRole.admin.name));
      expect(user.requiresPasswordChange, isFalse);
      expect(user.isActive, isTrue);

      // Password hash verification for 150613
      final isPasswordValid =
          PasswordHasher.verifyPassword('150613', user.salt, user.passwordHash);
      expect(isPasswordValid, isTrue);
    });

    test('seed() updates existing 430558 user password to 150613 and keeps role admin',
        () async {
      // First insert user with old password
      final oldSalt = PasswordHasher.generateSalt();
      final oldHash = PasswordHasher.hashPassword('EskiSifre123', oldSalt);

      await database.into(database.userTable).insert(
        UserTableCompanion.insert(
          username: '430558',
          passwordHash: oldHash,
          salt: oldSalt,
          fullName: 'Abdullah HAKYEMEZ',
          role: UserRole.admin.name,
        ),
      );

      // Run seeder
      final seeder = SeedDatabase(database);
      await seeder.seed();

      // Check updated user
      final user = await (database.select(database.userTable)
            ..where((tbl) => tbl.username.equals('430558')))
          .getSingle();

      expect(user.username, equals('430558'));
      expect(user.requiresPasswordChange, isFalse);

      final isNewPasswordValid =
          PasswordHasher.verifyPassword('150613', user.salt, user.passwordHash);
      expect(isNewPasswordValid, isTrue);
    });
  });
}
