import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/router/app_router.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';

import 'package:intl/date_symbol_data_local.dart';

class _FakeAuthRepo implements AuthRepository {
  final AppUser? initialUser;
  _FakeAuthRepo([this.initialUser]);

  @override
  Future<AppUser?> getSavedSession() async => initialUser;

  @override
  Future<AppUser> login(String username, String password) async {
    return initialUser!;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AppUser?> getUserById(int id) async => initialUser;

  @override
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {}
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('Auth Guard Router Tests', () {
    testWidgets('unauthenticated user is redirected to /login', (tester) async {
      final fakeRepo = _FakeAuthRepo(null);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      // Trigger session check
      await container.read(authControllerProvider.future);

      final router = container.read(appRouterProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, '/login');
      expect(find.text('GİRİŞ YAP'), findsOneWidget);
    });

    testWidgets('authenticated user on /login is redirected to /', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testUser = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );
      final fakeRepo = _FakeAuthRepo(testUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      // Trigger session check to resolve testUser
      await container.read(authControllerProvider.future);

      final router = container.read(appRouterProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should be on dashboard / shell
      expect(router.state.matchedLocation, '/');
      expect(find.text('Büro Amiri'), findsAtLeastNWidgets(1));
    });
  });
}
