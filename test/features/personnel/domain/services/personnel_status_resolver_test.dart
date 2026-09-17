import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/work_schedule.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';

void main() {
  group('PersonnelStatusResolver Priority & Business Logic Tests', () {
    final defaultSchedule = WorkSchedule(
      type: WorkScheduleType.twoPlusOne,
      dutyDays: 2,
      restDays: 1,
      startDate: DateTime(2026, 6, 1),
    );

    Personnel createTestPersonnel({
      String registryNumber = '100001',
      String fullName = 'Test Personeli',
      DateTime? startDate,
      DateTime? endDate,
      WorkSchedule? workSchedule,
      PersonnelStatus status = PersonnelStatus.duty,
    }) {
      return Personnel(
        id: 1,
        registryNumber: registryNumber,
        fullName: fullName,
        rank: 'Memur',
        title: 'Büro Personeli',
        branch: 'İdari İşler',
        department: 'Yönetim',
        startDate: startDate ?? DateTime(2025, 1, 1),
        endDate: endDate,
        phone: '5550001122',
        email: 'test@example.com',
        address: 'Test Adres',
        status: status,
        workSchedule: workSchedule,
      );
    }

    test('Separated personnel returns personnel.status after endDate', () {
      final person = createTestPersonnel(
        endDate: DateTime(2026, 5, 31),
        status: PersonnelStatus.resting,
        workSchedule: defaultSchedule,
      );

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: [],
        date: DateTime(2026, 6, 1),
      );
      expect(status, equals(PersonnelStatus.resting));
    });

    test('Not yet started personnel returns personnel.status before startDate', () {
      final person = createTestPersonnel(
        startDate: DateTime(2026, 7, 1),
        status: PersonnelStatus.duty,
        workSchedule: defaultSchedule,
      );

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: [],
        date: DateTime(2026, 6, 15),
      );
      expect(status, equals(PersonnelStatus.duty));
    });

    test('Report (sickReport) has top priority over work schedule', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);
      final leaves = [
        Leave(
          id: 'l-1',
          personnelId: 1,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 2),
          type: LeaveType.report,
          description: 'Sağlık Raporu',
        ),
      ];

      // 2026-06-01 would normally be a duty day in 2+1 schedule
      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
        date: DateTime(2026, 6, 1),
      );
      expect(status, equals(PersonnelStatus.sickReport));
    });

    test('Report (sickReport) has priority over Annual Leave on same day', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);
      final leaves = [
        Leave(
          id: 'l-annual',
          personnelId: 1,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 5),
          type: LeaveType.annual,
          description: 'Yıllık İzin',
        ),
        Leave(
          id: 'l-report',
          personnelId: 1,
          startDate: DateTime(2026, 6, 2),
          endDate: DateTime(2026, 6, 3),
          type: LeaveType.report,
          description: 'Rapor Çakışması',
        ),
      ];

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
        date: DateTime(2026, 6, 2),
      );
      expect(status, equals(PersonnelStatus.sickReport));
    });

    test('Annual Leave has priority over duty day', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);
      final leaves = [
        Leave(
          id: 'l-annual',
          personnelId: 1,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 5),
          type: LeaveType.annual,
          description: 'Yıllık İzin',
        ),
      ];

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
        date: DateTime(2026, 6, 1),
      );
      expect(status, equals(PersonnelStatus.leave));
    });

    test('Excuse Leave has priority over duty day', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);
      final leaves = [
        Leave(
          id: 'l-excuse',
          personnelId: 1,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 1),
          type: LeaveType.excuse,
          description: 'Mazeret İzni',
        ),
      ];

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
        date: DateTime(2026, 6, 1),
      );
      expect(status, equals(PersonnelStatus.leave));
    });

    group('Work schedule duty & rest day resolution without leaves', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);

      test('Duty Day 1 (Day 0) resolves to PersonnelStatus.duty', () {
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: [],
          date: DateTime(2026, 6, 1),
        );
        expect(status, equals(PersonnelStatus.duty));
      });

      test('Duty Day 2 (Day 1) resolves to PersonnelStatus.duty', () {
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: [],
          date: DateTime(2026, 6, 2),
        );
        expect(status, equals(PersonnelStatus.duty));
      });

      test('Rest Day (Day 2) resolves to PersonnelStatus.resting', () {
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: [],
          date: DateTime(2026, 6, 3),
        );
        expect(status, equals(PersonnelStatus.resting));
      });
    });

    test('Without work schedule, returns fallback personnel.status', () {
      final person = createTestPersonnel(
        workSchedule: null,
        status: PersonnelStatus.duty,
      );

      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: [],
        date: DateTime(2026, 6, 1),
      );
      expect(status, equals(PersonnelStatus.duty));
    });

    group('Leave Boundary Conditions (Start/End Days)', () {
      final person = createTestPersonnel(workSchedule: defaultSchedule);
      final leaves = [
        Leave(
          id: 'l-bound',
          personnelId: 1,
          startDate: DateTime(2026, 6, 2),
          endDate: DateTime(2026, 6, 4),
          type: LeaveType.annual,
          description: 'Sınır İzni',
        ),
      ];

      test('Day before leave starts follows normal work schedule', () {
        // 2026-06-01 is Day 0 (duty)
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: leaves,
          date: DateTime(2026, 6, 1),
        );
        expect(status, equals(PersonnelStatus.duty));
      });

      test('Exact start day of leave resolves to leave', () {
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: leaves,
          date: DateTime(2026, 6, 2),
        );
        expect(status, equals(PersonnelStatus.leave));
      });

      test('Exact end day of leave resolves to leave', () {
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: leaves,
          date: DateTime(2026, 6, 4),
        );
        expect(status, equals(PersonnelStatus.leave));
      });

      test('Day after leave ends follows normal work schedule', () {
        // 2026-06-05: 2026-06-01 was cycle day 0, 06-02 day 1, 06-03 day 2 (rest), 06-04 day 0, 06-05 day 1 (duty)
        final status = PersonnelStatusResolver.resolve(
          personnel: person,
          leaves: leaves,
          date: DateTime(2026, 6, 5),
        );
        expect(status, equals(PersonnelStatus.duty));
      });
    });
  });
}
