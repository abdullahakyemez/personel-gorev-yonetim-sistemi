import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/user_management_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/repositories/user_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/pages/user_management_page.dart';

class _FakeUserRepository implements UserRepository {
  List<AppUser> users;
  int? lastResetUserId;

  _FakeUserRepository(this.users);

  @override
  Future<List<AppUser>> getUsers() async => users;

  @override
  Future<AppUser> createUser({
    int? personnelId,
    required String registryNumber,
    required String fullName,
    required UserRole role,
    String? groupName,
  }) async {
    final newUser = AppUser(
      id: users.length + 1,
      username: registryNumber,
      fullName: fullName,
      role: role,
      personnelId: personnelId,
      groupName: groupName,
      requiresPasswordChange: true,
      createdAt: DateTime.now(),
    );
    users.add(newUser);
    return newUser;
  }

  @override
  Future<void> updateUser(
    int id, {
    required UserRole role,
    String? groupName,
    required bool isActive,
  }) async {
    final index = users.indexWhere((u) => u.id == id);
    if (index != -1) {
      users[index] = users[index].copyWith(
        role: role,
        groupName: groupName,
        isActive: isActive,
      );
    }
  }

  @override
  Future<void> resetPasswordToDefault(int userId) async {
    lastResetUserId = userId;
    final index = users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      users[index] = users[index].copyWith(requiresPasswordChange: true);
    }
  }

  @override
  Future<void> deleteUser(int id, int currentAdminId) async {
    users.removeWhere((u) => u.id == id);
  }
}

void main() {
  late _FakeUserRepository fakeUserRepo;
  late AppUser adminUser;
  late AppUser clerkUser;

  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  setUp(() {
    adminUser = AppUser(
      id: 1,
      username: 'admin',
      fullName: 'Büro Amiri Ali',
      role: UserRole.admin,
      requiresPasswordChange: false,
      createdAt: DateTime.now(),
    );

    clerkUser = AppUser(
      id: 2,
      username: '123456',
      fullName: 'Memur Mehmet',
      role: UserRole.officeClerk,
      groupName: 'Evrak Bürosu',
      requiresPasswordChange: true,
      createdAt: DateTime.now(),
    );

    fakeUserRepo = _FakeUserRepository([adminUser, clerkUser]);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(fakeUserRepo),
        currentUserProvider.overrideWith((ref) => adminUser),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        home: const UserManagementPage(),
      ),
    );
  }

  group('UserManagementPage Widget Tests', () {
    testWidgets('renders header, filters and user data table correctly', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Kullanıcı Yönetimi'), findsOneWidget);
      expect(find.text('Yeni Kullanıcı Tanımla'), findsOneWidget);
      expect(find.text('Büro Amiri Ali'), findsOneWidget);
      expect(find.text('Memur Mehmet'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('İlk Şifre (Pr123456)'), findsOneWidget);
    });

    testWidgets('filters users by search query', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Sicil No veya İsimle Ara...'),
        'Mehmet',
      );
      await tester.pumpAndSettle();

      expect(find.text('Memur Mehmet'), findsOneWidget);
      expect(find.text('Büro Amiri Ali'), findsNothing);
    });

    testWidgets('triggers password reset confirmation dialog and succeeds', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final resetBtn = find.byIcon(Icons.lock_reset_rounded).last;
      await tester.ensureVisible(resetBtn);
      await tester.pumpAndSettle();

      // Tap reset password icon for clerk
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(find.text('Şifreyi Standart Şifreye Sıfırla'), findsOneWidget);
      expect(find.textContaining('standart ilk şifre olan "Pr123456"'), findsOneWidget);

      await tester.tap(find.text('Şifreyi Sıfırla'));
      await tester.pumpAndSettle();

      expect(fakeUserRepo.lastResetUserId, 2);
      expect(find.textContaining('şifresi "Pr123456" olarak sıfırlandı'), findsOneWidget);
    });
  });
}
