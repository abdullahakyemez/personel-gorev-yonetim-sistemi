import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/access_scope.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';

void main() {
  group('AuthStateProvider Tests', () {
    test('initial state has no user and empty permissions', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(currentUserProvider), isNull);
      expect(container.read(currentPermissionsProvider), isEmpty);
      expect(container.read(hasPermissionProvider(AppPermission.viewPersonnel)), isFalse);
      expect(container.read(currentAccessScopeProvider), AccessScope.selfOnly);
    });

    test('updating currentUserProvider updates permissions and access scope reactively', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      container.read(currentUserProvider.notifier).state = user;

      expect(container.read(currentUserProvider), equals(user));
      expect(container.read(hasPermissionProvider(AppPermission.manageSettings)), isTrue);
      expect(container.read(hasPermissionProvider(AppPermission.createPersonnel)), isTrue);
      expect(container.read(currentAccessScopeProvider), AccessScope.all);
    });

    test('inactive user yields empty permissions', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final inactiveUser = AppUser(
        id: 2,
        username: 'inactive_clerk',
        fullName: 'Eski Memur',
        role: UserRole.officeClerk,
        isActive: false,
        createdAt: DateTime.now(),
      );

      container.read(currentUserProvider.notifier).state = inactiveUser;

      expect(container.read(currentPermissionsProvider), isEmpty);
      expect(container.read(hasPermissionProvider(AppPermission.createPersonnel)), isFalse);
    });
  });
}
