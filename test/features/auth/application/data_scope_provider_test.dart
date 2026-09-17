import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/data_scope_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

void main() {
  group('DataScopeFilter Tests', () {
    final now = DateTime.now();

    final person1 = Personnel(
      id: 1,
      registryNumber: '1001',
      fullName: 'Grup Amiri Ali',
      rank: 'Komiser',
      title: 'Grup Amiri',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2020, 1, 1),
      phone: '05551112233',
      email: 'ali@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    final person2 = Personnel(
      id: 2,
      registryNumber: '1002',
      fullName: 'Ekip Memuru Veli',
      rank: 'Polis Memuru',
      title: 'Ekip Memuru',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2021, 1, 1),
      phone: '05552223344',
      email: 'veli@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.leave,
    );

    final person3 = Personnel(
      id: 3,
      registryNumber: '1003',
      fullName: 'Farklı Grup Can',
      rank: 'Polis Memuru',
      title: 'Ekip Memuru',
      branch: 'Trafik',
      department: 'B Grubu',
      startDate: DateTime(2022, 1, 1),
      phone: '05553334455',
      email: 'can@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    final person4 = Personnel(
      id: 4,
      registryNumber: '1004',
      fullName: 'İzindeki B Grubu Ayşe',
      rank: 'Polis Memuru',
      title: 'Ekip Memuru',
      branch: 'Trafik',
      department: 'B Grubu',
      startDate: DateTime(2022, 1, 1),
      phone: '05554445566',
      email: 'ayse@egm.gov.tr',
      address: 'Ankara',
      status: PersonnelStatus.leave,
    );

    final personnelMap = <int, Personnel>{
      1: person1,
      2: person2,
      3: person3,
      4: person4,
    };

    final taskA = Task(
      id: 'task-a',
      personnelIds: [2],
      title: 'A Grubu Devriye',
      description: 'Devriye görevi',
      status: TaskStatus.inProgress,
      startDate: now.subtract(const Duration(hours: 1)),
      endDate: now.add(const Duration(hours: 5)),
    );

    final taskB = Task(
      id: 'task-b',
      personnelIds: [4],
      title: 'B Grubu Devriye',
      description: 'Trafik kontrolü',
      status: TaskStatus.completed,
      startDate: now.subtract(const Duration(days: 10)),
      endDate: now.subtract(const Duration(days: 9)),
    );

    final leave1 = Leave(
      id: 'leave-1',
      personnelId: 2,
      type: LeaveType.annual,
      startDate: now.subtract(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 5)),
      description: 'Yıllık izin',
    );

    final leave2 = Leave(
      id: 'leave-2',
      personnelId: 4,
      type: LeaveType.report,
      startDate: now.subtract(const Duration(days: 20)),
      endDate: now.subtract(const Duration(days: 15)),
      description: 'Geçmiş rapor',
    );

    test('Null currentUser allows all personnel, tasks, and leaves (Fallback)', () {
      const filter = DataScopeFilter(null);

      expect(filter.filterPersonnel(person1), isTrue);
      expect(filter.filterPersonnel(person4), isTrue);
      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterTask(taskB, personnelMap), isTrue);
      expect(filter.filterLeave(leave1, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isTrue);
    });

    test('Admin has full scope access', () {
      final adminUser = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: now,
      );
      final filter = DataScopeFilter(adminUser);

      expect(filter.filterPersonnel(person1), isTrue);
      expect(filter.filterPersonnel(person2), isTrue);
      expect(filter.filterPersonnel(person3), isTrue);
      expect(filter.filterPersonnel(person4), isTrue);

      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterTask(taskB, personnelMap), isTrue);

      expect(filter.filterLeave(leave1, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isTrue);
    });

    test('AssistantChief has full scope access', () {
      final asstUser = AppUser(
        id: 2,
        username: 'asst',
        fullName: 'Büro Amir Yrd',
        role: UserRole.assistantChief,
        createdAt: now,
      );
      final filter = DataScopeFilter(asstUser);

      expect(filter.filterPersonnel(person1), isTrue);
      expect(filter.filterPersonnel(person4), isTrue);
      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isTrue);
    });

    test('GroupChief only sees personnel from own group or active duty personnel', () {
      final chiefUser = AppUser(
        id: 3,
        username: '1001',
        fullName: 'Grup Amiri Ali',
        role: UserRole.groupChief,
        groupName: 'A Grubu',
        createdAt: now,
      );
      final filter = DataScopeFilter(chiefUser);

      expect(filter.filterPersonnel(person1), isTrue);
      expect(filter.filterPersonnel(person2), isTrue);
      expect(filter.filterPersonnel(person3), isTrue);
      expect(filter.filterPersonnel(person4), isFalse);

      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterTask(taskB, personnelMap), isFalse);

      expect(filter.filterLeave(leave1, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isFalse);
    });

    test('DeskOfficer only sees active duty personnel, active tasks, active leaves', () {
      final deskUser = AppUser(
        id: 4,
        username: 'desk',
        fullName: 'Nöbetçi Amir',
        role: UserRole.deskOfficer,
        createdAt: now,
      );
      final filter = DataScopeFilter(deskUser);

      expect(filter.filterPersonnel(person1), isTrue);
      expect(filter.filterPersonnel(person3), isTrue);
      expect(filter.filterPersonnel(person2), isFalse);
      expect(filter.filterPersonnel(person4), isFalse);

      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterTask(taskB, personnelMap), isFalse);

      expect(filter.filterLeave(leave1, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isFalse);
    });

    test('TeamOfficer only sees own personnel card, own tasks, and own leaves', () {
      final teamUser = AppUser(
        id: 5,
        username: '1002',
        fullName: 'Ekip Memuru Veli',
        role: UserRole.teamOfficer,
        personnelId: 2,
        createdAt: now,
      );
      final filter = DataScopeFilter(teamUser);

      expect(filter.filterPersonnel(person2), isTrue);
      expect(filter.filterPersonnel(person1), isFalse);
      expect(filter.filterPersonnel(person3), isFalse);
      expect(filter.filterPersonnel(person4), isFalse);

      expect(filter.filterTask(taskA, personnelMap), isTrue);
      expect(filter.filterTask(taskB, personnelMap), isFalse);

      expect(filter.filterLeave(leave1, personnelMap), isTrue);
      expect(filter.filterLeave(leave2, personnelMap), isFalse);
    });

    test('dataScopeFilterProvider reacts when currentUserProvider changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(dataScopeFilterProvider).currentUser, isNull);

      final user = AppUser(
        id: 99,
        username: 'admin',
        fullName: 'Admin',
        role: UserRole.admin,
        createdAt: now,
      );

      container.read(currentUserProvider.notifier).state = user;
      expect(container.read(dataScopeFilterProvider).currentUser, equals(user));
    });
  });
}
