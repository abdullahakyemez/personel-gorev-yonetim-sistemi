import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/dialogs/change_password_dialog.dart';

class _FakeAuthRepository implements AuthRepository {
  String? changedNewPassword;

  @override
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {
    changedNewPassword = newPassword;
  }

  @override
  Future<AppUser?> getSavedSession() async => null;

  @override
  Future<AppUser?> getUserById(int id) async => null;

  @override
  Future<AppUser> login(String username, String password) async => throw UnimplementedError();

  @override
  Future<void> logout() async {}
}

void main() {
  late _FakeAuthRepository fakeRepo;
  late AppUser testUser;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
    testUser = AppUser(
      id: 10,
      username: '998877',
      fullName: 'Mustafa Demir',
      role: UserRole.teamOfficer,
      requiresPasswordChange: true,
      createdAt: DateTime.now(),
    );
  });

  Widget createWidgetUnderTest({bool isFirstLogin = true}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeRepo),
        currentUserProvider.overrideWith((ref) => testUser),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ChangePasswordDialog(
                      user: testUser,
                      isFirstLogin: isFirstLogin,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('ChangePasswordDialog Widget Tests', () {
    testWidgets('renders first login notice and prefilled default password', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest(isFirstLogin: true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('İlk Giriş: Yeni Şifre Belirleme'), findsOneWidget);
      expect(find.textContaining('standart şifrenizi (Pr123456) değiştirmeniz zorunludur'), findsOneWidget);
      expect(find.text('Pr123456'), findsOneWidget);
      expect(find.text('Yeni Şifremi Kaydet'), findsOneWidget);
    });

    testWidgets('validates password constraints', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest(isFirstLogin: true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Submit with empty new password
      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Yeni şifrenizi giriniz.'), findsOneWidget);

      // Enter short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre'),
        '123',
      );
      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Şifre en az 6 karakter olmalıdır.'), findsOneWidget);

      // Enter Pr123456 as new password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre'),
        'Pr123456',
      );
      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Yeni şifre standart ilk şifre (Pr123456) olamaz.'), findsOneWidget);

      // Enter valid password but mismatching confirm
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre'),
        'YeniGuvenliSifre!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre Tekrar'),
        'BaskaBirSifre!',
      );
      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Girdiğiniz şifreler eşleşmiyor.'), findsOneWidget);
    });

    testWidgets('successfully saves new password and calls repository', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest(isFirstLogin: true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre'),
        'YeniGuvenliSifre!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yeni Şifre Tekrar'),
        'YeniGuvenliSifre!',
      );

      await tester.tap(find.text('Yeni Şifremi Kaydet'));
      await tester.pumpAndSettle();

      expect(fakeRepo.changedNewPassword, 'YeniGuvenliSifre!');
      expect(find.text('Şifreniz başarıyla güncellendi.'), findsOneWidget);
    });
  });
}
