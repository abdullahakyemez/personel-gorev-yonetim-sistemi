import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/password_hasher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late AuthRepositoryImpl authRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    authRepo = AuthRepositoryImpl(db, prefs);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertUser({
    required String username,
    required String password,
    required String fullName,
    required UserRole role,
    bool isActive = true,
  }) async {
    final salt = PasswordHasher.generateSalt();
    final passwordHash = PasswordHasher.hashPassword(password, salt);
    return db.into(db.userTable).insert(
      UserTableCompanion.insert(
        username: username,
        passwordHash: passwordHash,
        salt: salt,
        fullName: fullName,
        role: role.name,
        isActive: Value(isActive),
      ),
    );
  }

  group('AuthRepositoryImpl Tests', () {
    test('login with valid credentials successfully returns AppUser and stores session', () async {
      await insertUser(
        username: 'admin',
        password: 'Password123!',
        fullName: 'Ali Yılmaz',
        role: UserRole.admin,
      );

      final user = await authRepo.login('admin', 'Password123!');

      expect(user.username, 'admin');
      expect(user.fullName, 'Ali Yılmaz');
      expect(user.role, UserRole.admin);
      expect(user.lastLoginAt, isNotNull);
      expect(prefs.getInt('auth_user_id'), user.id);
    });

    test('login with case-insensitive username works', () async {
      await insertUser(
        username: 'mehmet_kaya',
        password: 'Password123!',
        fullName: 'Mehmet Kaya',
        role: UserRole.officeClerk,
      );

      final user = await authRepo.login('  MEHMET_KAYA  ', 'Password123!');
      expect(user.username, 'mehmet_kaya');
      expect(user.role, UserRole.officeClerk);
    });

    test('login with wrong password throws AuthException', () async {
      await insertUser(
        username: 'admin',
        password: 'Password123!',
        fullName: 'Admin User',
        role: UserRole.admin,
      );

      expect(
        () => authRepo.login('admin', 'WrongPass'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('Geçersiz kullanıcı adı veya şifre'),
        )),
      );
    });

    test('login with unknown username throws AuthException', () async {
      expect(
        () => authRepo.login('nonexistent', 'pass'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('Geçersiz kullanıcı adı veya şifre'),
        )),
      );
    });

    test('login with empty credentials throws AuthException', () async {
      expect(
        () => authRepo.login('', ''),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('boş bırakılamaz'),
        )),
      );
    });

    test('login with inactive user throws AuthException', () async {
      await insertUser(
        username: 'pasif_kullanici',
        password: 'Password123!',
        fullName: 'Pasif Memur',
        role: UserRole.teamOfficer,
        isActive: false,
      );

      expect(
        () => authRepo.login('pasif_kullanici', 'Password123!'),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('devre dışı'),
        )),
      );
    });

    test('logout clears saved session in SharedPreferences', () async {
      await prefs.setInt('auth_user_id', 99);
      expect(prefs.getInt('auth_user_id'), 99);

      await authRepo.logout();
      expect(prefs.getInt('auth_user_id'), isNull);
    });

    test('getSavedSession returns AppUser when valid session exists', () async {
      final userId = await insertUser(
        username: 'hasan_amir',
        password: 'Password123!',
        fullName: 'Hasan Amir',
        role: UserRole.assistantChief,
      );

      await prefs.setInt('auth_user_id', userId);

      final sessionUser = await authRepo.getSavedSession();
      expect(sessionUser, isNotNull);
      expect(sessionUser!.id, userId);
      expect(sessionUser.role, UserRole.assistantChief);
    });

    test('getSavedSession returns null and cleans prefs if user is deactivated or deleted', () async {
      final userId = await insertUser(
        username: 'deaktif_user',
        password: 'Password123!',
        fullName: 'Deaktif Kullanici',
        role: UserRole.deskOfficer,
        isActive: false,
      );

      await prefs.setInt('auth_user_id', userId);

      final sessionUser = await authRepo.getSavedSession();
      expect(sessionUser, isNull);
      expect(prefs.getInt('auth_user_id'), isNull);
    });
  });
}
