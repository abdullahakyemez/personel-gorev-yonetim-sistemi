import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/pages/personnel_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_profile_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('Scoped Personnel UI & Action Guards Tests', () {
    final person1 = Personnel(
      id: 1,
      registryNumber: '1001',
      fullName: 'Ahmet Yılmaz',
      rank: 'Uzman',
      title: 'Mühendis',
      branch: 'Yazılım',
      department: 'IT',
      startDate: DateTime(2020, 1, 1),
      phone: '05551112233',
      email: 'ahmet@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    final person2 = Personnel(
      id: 2,
      registryNumber: '1002',
      fullName: 'Veli Ekip',
      rank: 'Polis Memuru',
      title: 'Ekip Memuru',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2021, 1, 1),
      phone: '05552223344',
      email: 'veli@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    Widget createWidgetUnderTest({
      required AppUser user,
      int? initialSelectedId,
    }) {
      return ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => user),
          personnelListProvider.overrideWith((ref) async => [person1, person2]),
          taskControllerProvider.overrideWith(() => _MockTaskController()),
          leaveControllerProvider.overrideWith(() => _MockLeaveController()),
          personnelHistoryProvider.overrideWith((ref, id) async => <PersonnelHistory>[]),
          if (initialSelectedId != null)
            selectedPersonnelIdProvider.overrideWith((ref) => initialSelectedId),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: PersonnelPage(),
          ),
        ),
      );
    }

    testWidgets('TeamOfficer only sees own personnel card and action buttons are hidden',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final teamUser = AppUser(
        id: 10,
        username: '1002',
        fullName: 'Veli Ekip',
        role: UserRole.teamOfficer,
        personnelId: 2,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(user: teamUser));
      await tester.pumpAndSettle();

      // Only person2 (Veli Ekip) is visible
      expect(find.text('Veli Ekip'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsNothing);

      // 'Personel Ekle' and 'Excel Aktar' should be HIDDEN for teamOfficer
      expect(find.text('Personel Ekle'), findsNothing);
      expect(find.text('Excel Aktar'), findsNothing);
    });

    testWidgets('Admin sees all personnel and action buttons are visible',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final adminUser = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(user: adminUser));
      await tester.pumpAndSettle();

      // Both personnel should be visible
      expect(find.text('Ahmet Yılmaz'), findsOneWidget);
      expect(find.text('Veli Ekip'), findsOneWidget);

      // 'Personel Ekle' and 'Excel Aktar' should be VISIBLE for admin
      expect(find.text('Personel Ekle'), findsOneWidget);
      expect(find.text('Excel Aktar'), findsOneWidget);
    });

    testWidgets('PersonnelProfileCard guards Edit and Delete buttons based on permissions',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final teamUser = AppUser(
        id: 10,
        username: '1002',
        fullName: 'Veli Ekip',
        role: UserRole.teamOfficer,
        personnelId: 2,
        createdAt: DateTime.now(),
      );

      // Team officer selecting own card
      await tester.pumpWidget(createWidgetUnderTest(
        user: teamUser,
        initialSelectedId: 2,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(PersonnelProfileCard), findsOneWidget);
      // Team officer should NOT see Edit or Delete buttons
      expect(find.text('Düzenle'), findsNothing);
      expect(find.text('Sil'), findsNothing);
    });
  });
}

class _MockTaskController extends AsyncNotifier<List<Task>>
    implements TaskController {
  @override
  Future<List<Task>> build() async => [];
  @override
  Future<void> addTask(Task task) async {}
  @override
  Future<void> updateTask(Task task) async {}
  @override
  Future<void> deleteTask(String id) async {}
}

class _MockLeaveController extends AsyncNotifier<List<Leave>>
    implements LeaveController {
  @override
  Future<List<Leave>> build() async => [];
  @override
  Future<void> addLeave(Leave leave) async {}
  @override
  Future<void> updateLeave(Leave leave) async {}
  @override
  Future<void> deleteLeave(String id) async {}
  @override
  Future<void> refreshLeaves() async {}
}
