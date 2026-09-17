import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/data/repositories/user_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late UserRepositoryImpl userRepo;
  late AuthRepositoryImpl authRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    userRepo = UserRepositoryImpl(db);
    authRepo = AuthRepositoryImpl(db, prefs);
  });

  tearDown(() async {
    await db.close();
  });

  group('UserRepositoryImpl & First Login Password Flow Tests', () {
    test('createUser uses registryNumber as username, sets Pr123456 initial password and requiresPasswordChange: true', () async {
      final user = await userRepo.createUser(
        personnelId: 10,
        registryNumber: '987654',
        fullName: 'Ahmet Yılmaz',
        role: UserRole.officeClerk,
        groupName: 'Büro',
      );

      expect(user.username, '987654');
      expect(user.fullName, 'Ahmet Yılmaz');
      expect(user.role, UserRole.officeClerk);
      expect(user.personnelId, 10);
      expect(user.groupName, 'Büro');
      expect(user.isActive, isTrue);
      expect(user.requiresPasswordChange, isTrue);

      // Verify that user can login with default password Pr123456
      final loggedInUser = await authRepo.login('987654', 'Pr123456');
      expect(loggedInUser.id, user.id);
      expect(loggedInUser.requiresPasswordChange, isTrue);
    });

    test('createUser with duplicate registryNumber throws AuthException', () async {
      await userRepo.createUser(
        personnelId: 1,
        registryNumber: '112233',
        fullName: 'İlk Kullanıcı',
        role: UserRole.teamOfficer,
      );

      expect(
        () => userRepo.createUser(
          personnelId: 2,
          registryNumber: '112233',
          fullName: 'İkinci Kullanıcı',
          role: UserRole.teamOfficer,
        ),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('hesabı zaten mevcut'),
        )),
      );
    });

    test('getUsers returns all system users in ascending order', () async {
      await userRepo.createUser(
        personnelId: 1,
        registryNumber: '100001',
        fullName: 'Kullanıcı 1',
        role: UserRole.assistantChief,
      );
      await userRepo.createUser(
        personnelId: 2,
        registryNumber: '100002',
        fullName: 'Kullanıcı 2',
        role: UserRole.groupChief,
      );

      final users = await userRepo.getUsers();
      expect(users.length, 2);
      expect(users[0].username, '100001');
      expect(users[1].username, '100002');
    });

    test('updateUser modifies role, groupName and active status', () async {
      final user = await userRepo.createUser(
        personnelId: 1,
        registryNumber: '100003',
        fullName: 'Kullanıcı 3',
        role: UserRole.deskOfficer,
        groupName: 'Grup 1',
      );

      await userRepo.updateUser(
        user.id,
        role: UserRole.officeClerk,
        groupName: 'Grup 2',
        isActive: false,
      );

      final users = await userRepo.getUsers();
      final updated = users.firstWhere((u) => u.id == user.id);

      expect(updated.role, UserRole.officeClerk);
      expect(updated.groupName, 'Grup 2');
      expect(updated.isActive, isFalse);
    });

    test('resetPasswordToDefault sets password back to Pr123456 and flags requiresPasswordChange', () async {
      final user = await userRepo.createUser(
        personnelId: 1,
        registryNumber: '100004',
        fullName: 'Kullanıcı 4',
        role: UserRole.teamOfficer,
      );

      // User changes password first
      await authRepo.changePassword(user.id, 'Pr123456', 'MyNewSecret123');

      // Check that requiresPasswordChange is now false
      final changedUser = await authRepo.getUserById(user.id);
      expect(changedUser!.requiresPasswordChange, isFalse);

      // Admin resets password back to default
      await userRepo.resetPasswordToDefault(user.id);

      // Verify requiresPasswordChange is true again and user can login with Pr123456
      final resetUser = await authRepo.getUserById(user.id);
      expect(resetUser!.requiresPasswordChange, isTrue);

      final loggedIn = await authRepo.login('100004', 'Pr123456');
      expect(loggedIn.requiresPasswordChange, isTrue);
    });

    test('changePassword rejects password shorter than 6 characters or equal to Pr123456', () async {
      final user = await userRepo.createUser(
        personnelId: 1,
        registryNumber: '100005',
        fullName: 'Kullanıcı 5',
        role: UserRole.teamOfficer,
      );

      expect(
        () => authRepo.changePassword(user.id, 'Pr123456', '123'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('en az 6 karakter'),
        )),
      );

      expect(
        () => authRepo.changePassword(user.id, 'Pr123456', 'Pr123456'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('standart geçici şifre (Pr123456) olamaz'),
        )),
      );
    });

    test('deleteUser removes user but prevents admin from deleting themselves', () async {
      final adminUser = await userRepo.createUser(
        personnelId: 1,
        registryNumber: 'admin_test',
        fullName: 'Admin Test',
        role: UserRole.admin,
      );

      final clerkUser = await userRepo.createUser(
        personnelId: 2,
        registryNumber: 'clerk_test',
        fullName: 'Clerk Test',
        role: UserRole.officeClerk,
      );

      // Admin deleting self should throw
      expect(
        () => userRepo.deleteUser(adminUser.id, adminUser.id),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('Kendi yönetici hesabınızı silemezsiniz'),
        )),
      );

      // Admin deleting clerk should succeed
      await userRepo.deleteUser(clerkUser.id, adminUser.id);
      final remaining = await userRepo.getUsers();
      expect(remaining.any((u) => u.id == clerkUser.id), isFalse);
    });
  });
}
