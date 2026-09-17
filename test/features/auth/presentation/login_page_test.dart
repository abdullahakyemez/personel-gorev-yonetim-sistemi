import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/auth_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/pages/login_page.dart';

class _FakeAuthRepository implements AuthRepository {
  AppUser? sessionUser;
  bool shouldFail = false;
  String failMessage = 'Geçersiz kullanıcı adı veya şifre.';

  @override
  Future<AppUser?> getSavedSession() async => sessionUser;

  @override
  Future<AppUser> login(String username, String password) async {
    if (shouldFail) {
      throw AuthException(failMessage);
    }
    final user = AppUser(
      id: 1,
      username: username,
      fullName: 'Test Kullanıcısı',
      role: UserRole.admin,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    sessionUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    sessionUser = null;
  }

  @override
  Future<AppUser?> getUserById(int id) async => sessionUser;

  @override
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {}
}

void main() {
  late _FakeAuthRepository fakeRepo;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeRepo),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        home: const LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders all major components and form fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('PGYS'), findsOneWidget);
      expect(find.text('Personel ve Görev Yönetim Sistemi'), findsOneWidget);
      expect(find.text('Kullanıcı Adı'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
      expect(find.text('Giriş Yap'), findsOneWidget);
      expect(find.text('Kapalı Ağ Kurumsal Güvenlik Kalkanı'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are submitted empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Giriş Yap'));
      await tester.pumpAndSettle();

      expect(find.text('Kullanıcı adı giriniz.'), findsOneWidget);
      expect(find.text('Şifre giriniz.'), findsOneWidget);
    });

    testWidgets('toggles password visibility icon on click', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial eye icon is visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // After toggle, should be visibility_off_outlined
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('shows error feedback when login fails', (tester) async {
      fakeRepo.shouldFail = true;
      fakeRepo.failMessage = 'Hatalı şifre girdiniz.';

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kullanıcı Adı'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Şifre'),
        'wrongpass',
      );

      await tester.tap(find.text('Giriş Yap'));
      await tester.pumpAndSettle();

      expect(find.text('Hatalı şifre girdiniz.'), findsOneWidget);
    });

    testWidgets('successfully logs in with valid credentials', (tester) async {
      fakeRepo.shouldFail = false;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kullanıcı Adı'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Şifre'),
        'admin123',
      );

      await tester.tap(find.text('Giriş Yap'));
      await tester.pumpAndSettle();

      expect(find.text('Başarıyla giriş yapıldı. Hoş geldiniz!'), findsOneWidget);
    });
  });
}
