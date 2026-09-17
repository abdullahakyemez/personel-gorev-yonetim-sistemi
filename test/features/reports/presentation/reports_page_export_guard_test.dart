import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/pages/reports_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

void main() {
  group('ReportsPage Export Button Guard Tests', () {
    final testPersonnel = [
      Personnel(
        id: 1,
        registryNumber: 'SICIL001',
        fullName: 'Ahmet Yılmaz',
        rank: 'Polis Memuru',
        title: 'Ekip Personeli',
        branch: 'Asayiş',
        department: 'A Grubu',
        startDate: DateTime(2020, 1, 1),
        phone: '5551112233',
        email: 'ahmet@pgys.gov.tr',
        address: 'Adres',
        status: PersonnelStatus.duty,
      ),
    ];

    Widget createTestWidget({required AppUser user}) {
      return ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => user),
          personnelListProvider.overrideWith((ref) async => testPersonnel),
          leaveControllerProvider.overrideWith(() => _MockLeaveController([])),
          taskControllerProvider.overrideWith(() => _MockTaskController([])),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ReportsPage(),
          ),
        ),
      );
    }

    testWidgets('Admin user sees PDF and Excel export buttons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      final admin = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(user: admin));
      await tester.pumpAndSettle();

      expect(find.text('PDF Aktar'), findsOneWidget);
      expect(find.text('Excel Aktar'), findsOneWidget);
    });

    testWidgets('TeamOfficer user cannot see PDF and Excel export buttons',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      final teamOfficer = AppUser(
        id: 2,
        username: 'team',
        fullName: 'Ekip Memuru',
        role: UserRole.teamOfficer,
        personnelId: 1,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(user: teamOfficer));
      await tester.pumpAndSettle();

      expect(find.text('PDF Aktar'), findsNothing);
      expect(find.text('Excel Aktar'), findsNothing);
    });
  });
}

class _MockLeaveController extends AsyncNotifier<List<Leave>> implements LeaveController {
  final List<Leave> _leaves;
  _MockLeaveController(this._leaves);

  @override
  Future<List<Leave>> build() async => _leaves;
  @override
  Future<void> refreshLeaves() async {}
  @override
  Future<void> addLeave(Leave leave) async {}
  @override
  Future<void> updateLeave(Leave leave) async {}
  @override
  Future<void> deleteLeave(String id) async {}
}

class _MockTaskController extends AsyncNotifier<List<Task>> implements TaskController {
  final List<Task> _tasks;
  _MockTaskController(this._tasks);

  @override
  Future<List<Task>> build() async => _tasks;
  @override
  Future<void> addTask(Task task) async {}
  @override
  Future<void> updateTask(Task task) async {}
  @override
  Future<void> deleteTask(String id) async {}
}
