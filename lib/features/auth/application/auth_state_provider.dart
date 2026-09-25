import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/di/service_locator.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/models/access_scope.dart';
import '../domain/models/app_permission.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/services/permission_engine.dart';

/// AuthRepository sağlayıcısı (testlerde override edilebilir).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (getIt.isRegistered<AuthRepository>()) {
    return getIt<AuthRepository>();
  }
  return AuthRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

/// Aktif oturum açmış kullanıcıyı temsil eden StateProvider.
/// Başlangıçta null'dur (oturum kapalı).
final currentUserProvider = StateProvider<AppUser?>((ref) => null);

/// Aktif kullanıcının sahip olduğu tüm izinlerin kümesi.
final currentPermissionsProvider = Provider<Set<AppPermission>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || !user.isActive) return const {};
  return PermissionEngine.getPermissions(user.role);
});

/// Belirli bir izin için aktif kullanıcının yetkisi olup olmadığını kontrol eden Provider.family.
final hasPermissionProvider =
    Provider.family<bool, AppPermission>((ref, permission) {
  final permissions = ref.watch(currentPermissionsProvider);
  return permissions.contains(permission);
});

/// Aktif kullanıcının erişim kapsamı.
final currentAccessScopeProvider = Provider<AccessScope>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || !user.isActive) return AccessScope.selfOnly;
  return PermissionEngine.getScope(user.role);
});

/// Kimlik doğrulama işlemlerini ve oturum durumunu yöneten controller.
class AuthController extends AsyncNotifier<AppUser?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<AppUser?> build() async {
    final user = await _repository.getSavedSession();
    ref.read(currentUserProvider.notifier).state = user;
    return user;
  }

  Future<AppUser> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.login(username, password);
      ref.read(currentUserProvider.notifier).state = user;
      state = AsyncData(user);
      return user;
    } catch (e, st) {
      ref.read(currentUserProvider.notifier).state = null;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _repository.logout();
    } finally {
      ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncData(null);
    }
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AppUser?>(AuthController.new);

