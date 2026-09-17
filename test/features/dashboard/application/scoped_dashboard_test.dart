import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_statistics_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_today_roster_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/dashboard_statistics.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

void main() {
  group('Scoped Dashboard Providers Tests', () {
    final person1 = Personnel(
      id: 1,
      registryNumber: 'SICIL001',
      fullName: 'Ali Asayis',
      rank: 'Polis Memuru',
      title: 'Ekip Personeli',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2020, 1, 1),
      phone: '555111',
      email: 'ali@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.duty,
    );

    final person2 = Personnel(
      id: 2,
      registryNumber: 'SICIL002',
      fullName: 'Veli Trafik',
      rank: 'Polis Memuru',
      title: 'Ekip Personeli',
      branch: 'Trafik',
      department: 'B Grubu',
      startDate: DateTime(2021, 1, 1),
      phone: '555222',
      email: 'veli@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.resting,
    );

    final person3 = Personnel(
      id: 3,
      registryNumber: 'SICIL003',
      fullName: 'Ahmet Asayis',
      rank: 'Polis Memuru',
      title: 'Ekip Personeli',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2022, 1, 1),
      phone: '555333',
      email: 'ahmet@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.duty,
    );

    final allPersonnel = [person1, person2, person3];

    final now = DateTime.now();
    final task1 = Task(
      id: 't1',
      title: 'Devriye Görevi',
      description: 'Asayiş devriyesi',
      personnelIds: [1],
      startDate: now.subtract(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 1)),
      status: TaskStatus.inProgress,
    );

    final task2 = Task(
      id: 't2',
      title: 'Trafik Uygulaması',
      description: 'Trafik kontrol',
      personnelIds: [2],
      startDate: now.subtract(const Duration(days: 20)),
      endDate: now.subtract(const Duration(days: 15)),
      status: TaskStatus.completed,
    );

    final allTasks = [task1, task2];

    ProviderContainer createContainer(AppUser user) {
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((ref) => user),
          personnelListProvider.overrideWith((ref) async => allPersonnel),
          leaveControllerProvider.overrideWith(() => _MockLeaveController([])),
          taskControllerProvider.overrideWith(() => _MockTaskController(allTasks)),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('Admin sees all personnel and tasks in dashboardStatisticsProvider', () async {
      final admin = AppUser(
        id: 99,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      final container = createContainer(admin);
      await container.read(personnelListProvider.future);
      await container.read(leaveControllerProvider.future);
      await container.read(taskControllerProvider.future);

      final statsAsync = container.read(dashboardStatisticsProvider);
      expect(statsAsync.hasValue, isTrue);

      final stats = statsAsync.value as DashboardStatistics;
      expect(stats.totalPersonnel, 3);
      expect(stats.totalTasks, 2);
    });

    test('TeamOfficer (id: 1) only sees own personnel and own tasks in dashboard statistics', () async {
      final teamOfficer = AppUser(
        id: 1,
        username: 'SICIL001',
        fullName: 'Ali Asayis',
        role: UserRole.teamOfficer,
        personnelId: 1,
        createdAt: DateTime.now(),
      );

      final container = createContainer(teamOfficer);
      await container.read(personnelListProvider.future);
      await container.read(leaveControllerProvider.future);
      await container.read(taskControllerProvider.future);

      final statsAsync = container.read(dashboardStatisticsProvider);
      expect(statsAsync.hasValue, isTrue);

      final stats = statsAsync.value as DashboardStatistics;
      // Only sees own personnel record (1) and own task (1)
      expect(stats.totalPersonnel, 1);
      expect(stats.totalTasks, 1);
    });

    test('GroupChief (A Grubu) sees only Group A personnel and tasks in dashboard', () async {
      final groupChief = AppUser(
        id: 10,
        username: 'groupchief',
        fullName: 'Grup Amiri',
        role: UserRole.groupChief,
        groupName: 'A Grubu',
        createdAt: DateTime.now(),
      );

      final container = createContainer(groupChief);
      await container.read(personnelListProvider.future);
      await container.read(leaveControllerProvider.future);
      await container.read(taskControllerProvider.future);

      final statsAsync = container.read(dashboardStatisticsProvider);
      expect(statsAsync.hasValue, isTrue);

      final stats = statsAsync.value as DashboardStatistics;
      // Sees person1 and person3 from A Grubu, not person2 from B Grubu
      expect(stats.totalPersonnel, 2);
      expect(stats.totalTasks, 1); // task1 is assigned to person1 (A Grubu)

      final rosterAsync = container.read(todayRosterProvider);
      expect(rosterAsync.hasValue, isTrue);
      final roster = rosterAsync.value!;
      expect(roster.duty.length, 2);
      expect(roster.duty.any((p) => p.department == 'A Grubu'), isTrue);
      expect(roster.duty.any((p) => p.department == 'B Grubu'), isFalse);
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
