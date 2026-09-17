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
      expect(find.textContaining('PERSONEL VE GÖREV'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Sicil Numarası'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Şifre'), findsOneWidget);
      expect(find.text('GİRİŞ YAP'), findsOneWidget);
      expect(find.text('© 2026 Emniyet Teşkilatı'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are submitted empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('GİRİŞ YAP'));
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pumpAndSettle();

      expect(find.text('Sicil numaranızı giriniz'), findsOneWidget);
      expect(find.text('Şifrenizi giriniz'), findsOneWidget);
    });

    testWidgets('toggles password visibility icon on click', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial eye icon is visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // After toggle, should be visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows error feedback when login fails', (tester) async {
      fakeRepo.shouldFail = true;
      fakeRepo.failMessage = 'Hatalı şifre girdiniz.';

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sicil Numarası'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Şifre'),
        'wrongpass',
      );

      await tester.ensureVisible(find.text('GİRİŞ YAP'));
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pumpAndSettle();

      expect(find.text('Hatalı şifre girdiniz.'), findsOneWidget);
    });

    testWidgets('successfully logs in with valid credentials', (tester) async {
      fakeRepo.shouldFail = false;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sicil Numarası'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Şifre'),
        'admin123',
      );

      await tester.ensureVisible(find.text('GİRİŞ YAP'));
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pumpAndSettle();

      expect(find.text('Başarıyla giriş yapıldı. Hoş geldiniz!'), findsOneWidget);
    });
  });
}
