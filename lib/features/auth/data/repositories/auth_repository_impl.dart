import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/password_hasher.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _kSessionUserIdKey = 'auth_user_id';

  final AppDatabase _db;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._db, this._prefs);

  @override
  Future<AppUser?> getSavedSession() async {
    final userId = _prefs.getInt(_kSessionUserIdKey);
    if (userId == null) return null;

    final query = _db.select(_db.userTable)..where((u) => u.id.equals(userId));
    final userRow = await query.getSingleOrNull();

    if (userRow == null || !userRow.isActive) {
      await _prefs.remove(_kSessionUserIdKey);
      return null;
    }

    return _toAppUser(userRow);
  }

  @override
  Future<AppUser> login(String username, String password) async {
    final cleanUsername = username.trim().toLowerCase();
    if (cleanUsername.isEmpty || password.isEmpty) {
      throw const AuthException('Kullanıcı adı ve şifre boş bırakılamaz.');
    }

    final query = _db.select(_db.userTable)
      ..where((u) => u.username.lower().equals(cleanUsername));
    final userRow = await query.getSingleOrNull();

    if (userRow == null) {
      throw const AuthException('Geçersiz kullanıcı adı veya şifre.');
    }

    if (!userRow.isActive) {
      throw const AuthException(
        'Kullanıcı hesabı devre dışı bırakılmıştır. Lütfen yöneticiniz ile görüşün.',
      );
    }

    final now = DateTime.now();
    if (userRow.lockedUntil != null && userRow.lockedUntil!.isAfter(now)) {
      final diff = userRow.lockedUntil!.difference(now).inSeconds;
      final remainingSeconds = diff > 0 ? diff : 1;
      throw AccountLockedException(remainingSeconds);
    }

    final isValid = PasswordHasher.verifyPassword(
      password,
      userRow.salt,
      userRow.passwordHash,
    );

    if (!isValid) {
      final wasLockedAndExpired =
          userRow.lockedUntil != null && !userRow.lockedUntil!.isAfter(now);
      final currentAttempts = wasLockedAndExpired ? 0 : userRow.failedLoginAttempts;
      final newAttempts = currentAttempts + 1;

      if (newAttempts >= 5) {
        final lockExpiry = now.add(const Duration(seconds: 60));
        await (_db.update(_db.userTable)..where((u) => u.id.equals(userRow.id))).write(
          UserTableCompanion(
            failedLoginAttempts: Value(newAttempts),
            lockedUntil: Value(lockExpiry),
          ),
        );
        throw AccountLockedException(60);
      } else {
        await (_db.update(_db.userTable)..where((u) => u.id.equals(userRow.id))).write(
          UserTableCompanion(
            failedLoginAttempts: Value(newAttempts),
            lockedUntil: const Value(null),
          ),
        );
        throw const AuthException('Geçersiz kullanıcı adı veya şifre.');
      }
    }

    var companion = UserTableCompanion(
      lastLoginAt: Value(now),
      failedLoginAttempts: const Value(0),
      lockedUntil: const Value(null),
    );

    if (PasswordHasher.isLegacyHash(userRow.passwordHash)) {
      final newSalt = PasswordHasher.generateSalt();
      final newHash = PasswordHasher.hashPassword(password, newSalt);
      companion = companion.copyWith(
        passwordHash: Value(newHash),
        salt: Value(newSalt),
      );
    }

    await (_db.update(_db.userTable)..where((u) => u.id.equals(userRow.id))).write(companion);

    await _prefs.setInt(_kSessionUserIdKey, userRow.id);

    return _toAppUser(
      userRow.copyWith(
        lastLoginAt: Value(now),
        failedLoginAttempts: 0,
        lockedUntil: const Value(null),
      ),
    );
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_kSessionUserIdKey);
  }

  @override
  Future<AppUser?> getUserById(int id) async {
    final query = _db.select(_db.userTable)..where((u) => u.id.equals(id));
    final userRow = await query.getSingleOrNull();
    if (userRow == null) return null;
    return _toAppUser(userRow);
  }

  @override
  Future<void> changePassword(
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    if (newPassword.trim().length < 6) {
      throw const AuthException('Yeni şifre en az 6 karakter olmalıdır.');
    }
    if (newPassword == 'Pr123456') {
      throw const AuthException(
        'Yeni şifreniz standart geçici şifre (Pr123456) olamaz.',
      );
    }

    final query = _db.select(_db.userTable)..where((u) => u.id.equals(userId));
    final userRow = await query.getSingleOrNull();
    if (userRow == null) {
      throw const AuthException('Kullanıcı bulunamadı.');
    }

    final isOldValid = PasswordHasher.verifyPassword(
      oldPassword,
      userRow.salt,
      userRow.passwordHash,
    );
    if (!isOldValid) {
      throw const AuthException('Mevcut şifreniz hatalıdır.');
    }

    final newSalt = PasswordHasher.generateSalt();
    final newHash = PasswordHasher.hashPassword(newPassword, newSalt);

    await (_db.update(_db.userTable)..where((u) => u.id.equals(userId))).write(
      UserTableCompanion(
        passwordHash: Value(newHash),
        salt: Value(newSalt),
        requiresPasswordChange: const Value(false),
      ),
    );
  }

  AppUser _toAppUser(UserTableData row) {
    final role = UserRole.values.firstWhere(
      (r) => r.name == row.role,
      orElse: () => UserRole.teamOfficer,
    );
    return AppUser(
      id: row.id,
      username: row.username,
      fullName: row.fullName,
      role: role,
      personnelId: row.personnelId,
      groupName: row.groupName,
      isActive: row.isActive,
      requiresPasswordChange: row.requiresPasswordChange,
      createdAt: row.createdAt,
      lastLoginAt: row.lastLoginAt,
    );
  }
}
