import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/services/password_hasher.dart';

class UserRepositoryImpl implements UserRepository {
  static const String defaultInitialPassword = 'Pr123456';

  final AppDatabase _db;

  UserRepositoryImpl(this._db);

  @override
  Future<List<AppUser>> getUsers() async {
    final rows = await (_db.select(_db.userTable)
          ..orderBy([(u) => OrderingTerm(expression: u.id, mode: OrderingMode.asc)]))
        .get();

    return rows.map(_toAppUser).toList();
  }

  @override
  Future<AppUser> createUser({
    int? personnelId,
    required String registryNumber,
    required String fullName,
    required UserRole role,
    String? groupName,
  }) async {
    final cleanUsername = registryNumber.trim().toLowerCase();
    if (cleanUsername.isEmpty) {
      throw const AuthException('Sicil numarası boş bırakılamaz.');
    }

    // Kullanıcı adı daha önce alınmış mı?
    final existing = await (_db.select(_db.userTable)
          ..where((u) => u.username.lower().equals(cleanUsername)))
        .getSingleOrNull();

    if (existing != null) {
      throw AuthException(
        'Bu sicil numarasına ($cleanUsername) ait bir kullanıcı hesabı zaten mevcut.',
      );
    }

    final salt = PasswordHasher.generateSalt();
    final passwordHash =
        PasswordHasher.hashPassword(defaultInitialPassword, salt);

    final id = await _db.into(_db.userTable).insert(
          UserTableCompanion.insert(
            username: cleanUsername,
            passwordHash: passwordHash,
            salt: salt,
            fullName: fullName.trim(),
            role: role.name,
            personnelId: Value(personnelId),
            groupName: Value(groupName?.trim()),
            isActive: const Value(true),
            requiresPasswordChange: const Value(true),
          ),
        );

    return AppUser(
      id: id,
      username: cleanUsername,
      fullName: fullName.trim(),
      role: role,
      personnelId: personnelId,
      groupName: groupName?.trim(),
      isActive: true,
      requiresPasswordChange: true,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateUser(
    int id, {
    required UserRole role,
    String? groupName,
    required bool isActive,
  }) async {
    final count = await (_db.update(_db.userTable)
          ..where((u) => u.id.equals(id)))
        .write(
      UserTableCompanion(
        role: Value(role.name),
        groupName: Value(groupName?.trim()),
        isActive: Value(isActive),
      ),
    );

    if (count == 0) {
      throw const AuthException('Kullanıcı bulunamadı.');
    }
  }

  @override
  Future<void> resetPasswordToDefault(int userId) async {
    final salt = PasswordHasher.generateSalt();
    final passwordHash =
        PasswordHasher.hashPassword(defaultInitialPassword, salt);

    final count = await (_db.update(_db.userTable)
          ..where((u) => u.id.equals(userId)))
        .write(
      UserTableCompanion(
        passwordHash: Value(passwordHash),
        salt: Value(salt),
        requiresPasswordChange: const Value(true),
      ),
    );

    if (count == 0) {
      throw const AuthException('Kullanıcı bulunamadı.');
    }
  }

  @override
  Future<void> deleteUser(int id, int currentAdminId) async {
    if (id == currentAdminId) {
      throw const AuthException('Kendi yönetici hesabınızı silemezsiniz.');
    }

    final count = await (_db.delete(_db.userTable)
          ..where((u) => u.id.equals(id)))
        .go();

    if (count == 0) {
      throw const AuthException('Kullanıcı bulunamadı.');
    }
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
