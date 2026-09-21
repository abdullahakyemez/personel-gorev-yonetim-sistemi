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

    test('5 consecutive failed login attempts locks the user account for 60 seconds', () async {
      final userId = await insertUser(
        username: 'brute_force_user',
        password: 'CorrectPassword123!',
        fullName: 'Test User',
        role: UserRole.teamOfficer,
      );

      // Attempts 1 to 4 should throw standard invalid credentials AuthException
      for (var i = 1; i <= 4; i++) {
        await expectLater(
          () => authRepo.login('brute_force_user', 'WrongPass'),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              contains('Geçersiz kullanıcı adı veya şifre'),
            ),
          ),
        );

        final user = await (db.select(db.userTable)..where((u) => u.id.equals(userId))).getSingle();
        expect(user.failedLoginAttempts, i);
        expect(user.lockedUntil, isNull);
      }

      // 5th attempt triggers lockout
      await expectLater(
        () => authRepo.login('brute_force_user', 'WrongPass'),
        throwsA(
          isA<AccountLockedException>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('Çok fazla başarısız deneme'),
              contains('60 saniye'),
            ),
          ),
        ),
      );

      final lockedUser = await (db.select(db.userTable)..where((u) => u.id.equals(userId))).getSingle();
      expect(lockedUser.failedLoginAttempts, 5);
      expect(lockedUser.lockedUntil, isNotNull);
      expect(lockedUser.lockedUntil!.isAfter(DateTime.now()), isTrue);

      // Attempt while locked (even with correct password) must be rejected
      await expectLater(
        () => authRepo.login('brute_force_user', 'CorrectPassword123!'),
        throwsA(
          isA<AccountLockedException>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('Çok fazla başarısız deneme'),
              contains('saniye sonra tekrar deneyin'),
            ),
          ),
        ),
      );
    });

    test('successful login resets failedLoginAttempts counter', () async {
      final userId = await insertUser(
        username: 'reset_counter_user',
        password: 'ValidPassword123!',
        fullName: 'Reset User',
        role: UserRole.teamOfficer,
      );

      // 3 failed attempts
      for (var i = 0; i < 3; i++) {
        try {
          await authRepo.login('reset_counter_user', 'WrongPass');
        } catch (_) {}
      }

      var user = await (db.select(db.userTable)..where((u) => u.id.equals(userId))).getSingle();
      expect(user.failedLoginAttempts, 3);

      // Successful login
      final loggedIn = await authRepo.login('reset_counter_user', 'ValidPassword123!');
      expect(loggedIn.username, 'reset_counter_user');

      user = await (db.select(db.userTable)..where((u) => u.id.equals(userId))).getSingle();
      expect(user.failedLoginAttempts, 0);
      expect(user.lockedUntil, isNull);
    });

    test('login succeeds after lock period expires and resets lock state', () async {
      final userId = await insertUser(
        username: 'expired_lock_user',
        password: 'ValidPassword123!',
        fullName: 'Expired Lock User',
        role: UserRole.teamOfficer,
      );

      // Set lock in the past
      final pastLock = DateTime.now().subtract(const Duration(seconds: 5));
      await (db.update(db.userTable)..where((u) => u.id.equals(userId))).write(
        UserTableCompanion(
          failedLoginAttempts: const Value(5),
          lockedUntil: Value(pastLock),
        ),
      );

      // Login with correct password should succeed
      final loggedIn = await authRepo.login('expired_lock_user', 'ValidPassword123!');
      expect(loggedIn.username, 'expired_lock_user');

      final user = await (db.select(db.userTable)..where((u) => u.id.equals(userId))).getSingle();
      expect(user.failedLoginAttempts, 0);
      expect(user.lockedUntil, isNull);
    });
  });
}
