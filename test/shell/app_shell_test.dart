import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/presentation/pages/app_shell.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_topbar.dart';

class _FakeAuthRepo implements AuthRepository {
  bool logoutCalled = false;
  String? updatedNewPassword;

  @override
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {
    updatedNewPassword = newPassword;
  }

  @override
  Future<AppUser?> getSavedSession() async => null;

  @override
  Future<AppUser?> getUserById(int id) async => null;

  @override
  Future<AppUser> login(String username, String password) async => throw UnimplementedError();

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('AppShell & Forced Password Change Tests', () {
    late _FakeAuthRepo fakeRepo;

    setUp(() {
      fakeRepo = _FakeAuthRepo();
    });

    Widget createWidgetUnderTest({required AppUser user}) {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
          currentUserProvider.overrideWith((ref) => user),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          home: const AppShell(
            child: Text('Gizli_Dashboard_Icerigi'),
          ),
        ),
      );
    }

    testWidgets('requiresPasswordChange blocks dashboard and shows forced password form',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final forcedUser = AppUser(
        id: 5,
        username: '123456',
        fullName: 'Yeni Memur',
        role: UserRole.teamOfficer,
        groupName: 'A Grubu',
        requiresPasswordChange: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(user: forcedUser));
      await tester.pumpAndSettle();

      // Dashboard contents must NOT be visible
      expect(find.text('Gizli_Dashboard_Icerigi'), findsNothing);

      // Forced password form must be visible
      expect(find.text('İlk Giriş: Yeni Şifre Belirleme'), findsOneWidget);
      expect(find.text('Pr123456'), findsOneWidget);
      expect(find.text('Yeni Şifremi Kaydet'), findsOneWidget);
      expect(find.text('Çıkış Yap'), findsOneWidget);

      // Fill in new password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre'),
        'YeniGucluSifre2026',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre Tekrar'),
        'YeniGucluSifre2026',
      );

      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(fakeRepo.updatedNewPassword, equals('YeniGucluSifre2026'));

      // After password change, dashboard content becomes visible!
      expect(find.text('Gizli_Dashboard_Icerigi'), findsOneWidget);
    });

    testWidgets('normal user displays AppTopbar with Name, Sicil, Group and Logout button',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final normalUser = AppUser(
        id: 1,
        username: '987654',
        fullName: 'Ali Komiser',
        role: UserRole.groupChief,
        groupName: 'B Grubu',
        requiresPasswordChange: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(user: normalUser));
      await tester.pumpAndSettle();

      // Dashboard content is visible
      expect(find.text('Gizli_Dashboard_Icerigi'), findsOneWidget);

      // AppTopbar details
      expect(find.byType(AppTopbar), findsOneWidget);
      expect(find.text('Ali Komiser'), findsOneWidget);
      expect(find.text('Grup Amiri'), findsOneWidget);
      expect(find.text('Sicil: 987654 • B Grubu'), findsOneWidget);

      // Logout icon is present
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });
  });
}
