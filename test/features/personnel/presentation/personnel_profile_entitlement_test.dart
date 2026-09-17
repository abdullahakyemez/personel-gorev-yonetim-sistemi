import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_profile_card.dart';

void main() {
  group('PersonnelProfileCard Leave Entitlement Widget Tests', () {
    testWidgets('renders seniority, quota, used days and remaining days correctly',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final now = DateTime.now();
      final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);

      final person = Personnel(
        id: 10,
        registryNumber: 'SICIL123',
        fullName: 'Ali Yılmaz',
        rank: 'Kıdemli Başpolis',
        title: 'Büro Amiri',
        branch: 'Asayiş',
        department: 'Cinayet',
        startDate: fiveYearsAgo,
        phone: '5551234567',
        email: 'ali@pgys.gov.tr',
        address: 'Adres',
        status: PersonnelStatus.duty,
      );

      final testLeaves = [
        Leave(
          id: 'l0',
          personnelId: 10,
          type: LeaveType.annual,
          startDate: DateTime(now.year - 1, 6, 1),
          endDate: DateTime(now.year - 1, 6, 24), // 24 days used in previous year (0 carryover)
          description: 'Geçen yıl izni',
        ),
        Leave(
          id: 'l1',
          personnelId: 10,
          type: LeaveType.annual,
          startDate: DateTime(now.year, 6, 1),
          endDate: DateTime(now.year, 6, 5), // 5 days
          description: 'Yaz izni',
        ),
        Leave(
          id: 'l2',
          personnelId: 10,
          type: LeaveType.excuse,
          startDate: DateTime(now.year, 3, 1),
          endDate: DateTime(now.year, 3, 2), // 2 days
          description: 'Mazeret izni',
        ),
      ];

      final adminUser = AppUser(
        id: 1,
        username: '123456',
        fullName: 'Admin User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => adminUser),
            leaveControllerProvider.overrideWith(() => _MockLeaveController(testLeaves)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: PersonnelProfileCard(person: person),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check entitlement header
      expect(find.textContaining('İzin Hak Ediş & Bakiye'), findsOneWidget);
      expect(find.text('Kıdem: 5 Yıl'), findsOneWidget);

      // Check 1-10 year quota (24 days)
      expect(find.text('Yıllık Hak: '), findsOneWidget);
      expect(find.text('24 Gün'), findsOneWidget);

      // Check used annual days (5 days)
      expect(find.text('Kullanılan: '), findsOneWidget);
      expect(find.text('5 Gün'), findsOneWidget);

      // Check remaining days (24 - 5 = 19 Gün)
      expect(find.text('Kalan İzin: '), findsOneWidget);
      expect(find.text('19 Gün'), findsOneWidget);

      // Check excuse days (2 Gün)
      expect(find.text('Mazeret: '), findsOneWidget);
      expect(find.text('2 Gün'), findsOneWidget);
    });

    testWidgets('renders carryover (devreden) badge and updated total entitlement when leave carried over',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final now = DateTime.now();
      final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);

      final person = Personnel(
        id: 10,
        registryNumber: 'SICIL123',
        fullName: 'Ali Yılmaz',
        rank: 'Kıdemli Başpolis',
        title: 'Büro Amiri',
        branch: 'Asayiş',
        department: 'Cinayet',
        startDate: fiveYearsAgo,
        phone: '5551234567',
        email: 'ali@pgys.gov.tr',
        address: 'Adres',
        status: PersonnelStatus.duty,
      );

      // 14 days used in previous year -> 10 days carried over
      final testLeaves = [
        Leave(
          id: 'l0',
          personnelId: 10,
          type: LeaveType.annual,
          startDate: DateTime(now.year - 1, 6, 1),
          endDate: DateTime(now.year - 1, 6, 14), // 14 days in prev year -> 10 remain
          description: 'Geçen yıl izni',
        ),
        Leave(
          id: 'l1',
          personnelId: 10,
          type: LeaveType.annual,
          startDate: DateTime(now.year, 6, 1),
          endDate: DateTime(now.year, 6, 5), // 5 days
          description: 'Yaz izni',
        ),
      ];

      final adminUser = AppUser(
        id: 1,
        username: '123456',
        fullName: 'Admin User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => adminUser),
            leaveControllerProvider.overrideWith(() => _MockLeaveController(testLeaves)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: PersonnelProfileCard(person: person),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check Devreden metric
      expect(find.text('Devreden: '), findsOneWidget);
      expect(find.text('10 Gün'), findsOneWidget);

      // Check Toplam Hak metric (24 base + 10 devreden = 34 Gün)
      expect(find.text('Toplam Hak: '), findsOneWidget);
      expect(find.text('34 Gün'), findsOneWidget);

      // Check Remaining (34 - 5 = 29 Gün)
      expect(find.text('Kalan İzin: '), findsOneWidget);
      expect(find.text('29 Gün'), findsOneWidget);
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
