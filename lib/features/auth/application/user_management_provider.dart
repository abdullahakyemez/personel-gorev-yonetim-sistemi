import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/di/service_locator.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/models/app_user.dart';
import '../domain/models/user_role.dart';
import '../domain/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  if (getIt.isRegistered<UserRepository>()) {
    return getIt<UserRepository>();
  }
  return UserRepositoryImpl(ref.watch(databaseProvider));
});

class UserManagementController extends AsyncNotifier<List<AppUser>> {
  UserRepository get _repository => ref.read(userRepositoryProvider);

  @override
  Future<List<AppUser>> build() async {
    return _repository.getUsers();
  }

  Future<void> refreshUsers() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getUsers());
  }

  Future<AppUser> createUser({
    int? personnelId,
    required String registryNumber,
    required String fullName,
    required UserRole role,
    String? groupName,
  }) async {
    final user = await _repository.createUser(
      personnelId: personnelId,
      registryNumber: registryNumber,
      fullName: fullName,
      role: role,
      groupName: groupName,
    );
    await refreshUsers();
    return user;
  }

  Future<void> updateUser(
    int id, {
    required UserRole role,
    String? groupName,
    required bool isActive,
  }) async {
    await _repository.updateUser(
      id,
      role: role,
      groupName: groupName,
      isActive: isActive,
    );
    await refreshUsers();
  }

  Future<void> resetPasswordToDefault(int userId) async {
    await _repository.resetPasswordToDefault(userId);
    await refreshUsers();
  }

  Future<void> deleteUser(int id, int currentAdminId) async {
    await _repository.deleteUser(id, currentAdminId);
    await refreshUsers();
  }
}

final userManagementProvider =
    AsyncNotifierProvider<UserManagementController, List<AppUser>>(
  UserManagementController.new,
);
