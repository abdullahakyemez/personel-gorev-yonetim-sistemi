import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/services/leave_entitlement_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

void main() {
  const service = LeaveEntitlementService();

  group('LeaveEntitlementService Seniority Calculation Tests', () {
    test('startDate within last 12 months returns 0 years', () {
      final asOf = DateTime(2026, 9, 17);
      final startDate = DateTime(2026, 1, 15);
      expect(service.calculateSeniorityYears(startDate, asOf), 0);

      // 1 day before full year
      final almostOneYear = DateTime(2025, 9, 18);
      expect(service.calculateSeniorityYears(almostOneYear, asOf), 0);
    });

    test('exact anniversary returns full years', () {
      final asOf = DateTime(2026, 9, 17);
      final exactOneYear = DateTime(2025, 9, 17);
      expect(service.calculateSeniorityYears(exactOneYear, asOf), 1);

      final exactFiveYears = DateTime(2021, 9, 17);
      expect(service.calculateSeniorityYears(exactFiveYears, asOf), 5);

      final exactTenYears = DateTime(2016, 9, 17);
      expect(service.calculateSeniorityYears(exactTenYears, asOf), 10);

      final exactElevenYears = DateTime(2015, 9, 17);
      expect(service.calculateSeniorityYears(exactElevenYears, asOf), 11);
    });

    test('future startDate gracefully returns 0 years', () {
      final asOf = DateTime(2026, 9, 17);
      final futureDate = DateTime(2027, 1, 1);
      expect(service.calculateSeniorityYears(futureDate, asOf), 0);
    });
  });

  group('LeaveEntitlementService Annual Quota Business Rule Tests', () {
    test('<1 year seniority gets 0 days entitlement', () {
      expect(service.calculateAnnualQuota(0), 0);
    });

    test('1 to 10 years (until completing 10th year) gets 24 days entitlement', () {
      expect(service.calculateAnnualQuota(1), 24);
      expect(service.calculateAnnualQuota(2), 24);
      expect(service.calculateAnnualQuota(5), 24);
      expect(service.calculateAnnualQuota(9), 24);
    });

    test('10 years completed and above gets 34 days entitlement', () {
      expect(service.calculateAnnualQuota(10), 34);
      expect(service.calculateAnnualQuota(11), 34);
      expect(service.calculateAnnualQuota(15), 34);
      expect(service.calculateAnnualQuota(25), 34);
    });
  });

  group('LeaveEntitlementService Balance Calculation Tests', () {
    final personJunior = Personnel(
      id: 1,
      registryNumber: 'SICIL001',
      fullName: 'Yeni Personel',
      rank: 'Memur',
      title: 'Zabıt Katibi',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2026, 3, 1),
      phone: '5551112233',
      email: 'yeni@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.duty,
    );

    final personMid = Personnel(
      id: 2,
      registryNumber: 'SICIL002',
      fullName: 'Kıdemli Personel (5 Yıl)',
      rank: 'Polis Memuru',
      title: 'Devriye',
      branch: 'Trafik',
      department: 'B Grubu',
      startDate: DateTime(2021, 6, 1),
      phone: '5552223344',
      email: 'mid@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.duty,
    );

    final personSenior = Personnel(
      id: 3,
      registryNumber: 'SICIL003',
      fullName: 'Kıdemli Başpolis (12 Yıl)',
      rank: 'Başpolis',
      title: 'Grup Amiri',
      branch: 'Asayiş',
      department: 'A Grubu',
      startDate: DateTime(2014, 1, 1),
      phone: '5553334455',
      email: 'senior@pgys.gov.tr',
      address: 'Adres',
      status: PersonnelStatus.duty,
    );

    final asOfDate = DateTime(2026, 9, 17);

    test('junior personnel with <1 year gets 0 total days and 0 remaining', () {
      final entitlement = service.calculate(
        personnel: personJunior,
        leaves: [],
        targetYear: 2026,
        asOfDate: asOfDate,
      );

      expect(entitlement.seniorityYears, 0);
      expect(entitlement.totalAnnualDays, 0);
      expect(entitlement.usedAnnualDays, 0);
      expect(entitlement.remainingAnnualDays, 0);
      expect(entitlement.usagePercentage, 0.0);
    });

    test('mid-seniority personnel (1-10 years) calculates carryover, remaining and percentages correctly', () {
      final leaves = [
        Leave(
          id: 'l1',
          personnelId: 2,
          type: LeaveType.annual,
          startDate: DateTime(2026, 7, 1),
          endDate: DateTime(2026, 7, 10),
          description: 'Yaz izni',
        ),
        Leave(
          id: 'l2',
          personnelId: 2,
          type: LeaveType.excuse,
          startDate: DateTime(2026, 4, 1),
          endDate: DateTime(2026, 4, 3),
          description: 'Mazeret',
        ),
        Leave(
          id: 'l3',
          personnelId: 2,
          type: LeaveType.report,
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 2, 5),
          description: 'İstirahat raporu',
        ),
        Leave(
          id: 'l4',
          personnelId: 99,
          type: LeaveType.annual,
          startDate: DateTime(2026, 7, 1),
          endDate: DateTime(2026, 7, 15),
          description: 'Başkası',
        ),
        Leave(
          id: 'l5',
          personnelId: 2,
          type: LeaveType.annual,
          startDate: DateTime(2025, 8, 1),
          endDate: DateTime(2025, 8, 14), // 14 days in 2025 -> 24 - 14 = 10 days remain
          description: '2025 izni',
        ),
      ];

      final entitlement = service.calculate(
        personnel: personMid,
        leaves: leaves,
        targetYear: 2026,
        asOfDate: asOfDate,
      );

      expect(entitlement.seniorityYears, 5);
      expect(entitlement.baseAnnualQuota, 24);
      expect(entitlement.transferredDays, 10);
      expect(entitlement.totalAnnualDays, 34); // 24 + 10 = 34
      expect(entitlement.usedAnnualDays, 10);
      expect(entitlement.remainingAnnualDays, 24); // 34 - 10 = 24
      expect(entitlement.usedExcuseDays, 3);
      expect(entitlement.usedReportDays, 5);
      expect(entitlement.usagePercentage, closeTo(10 / 34, 0.001));
    });

    test('senior personnel (>10 years) has 34 days quota and clamps remaining to 0 if exceeded (when prev year fully used)', () {
      final leaves = [
        Leave(
          id: 'l0',
          personnelId: 3,
          type: LeaveType.annual,
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 2, 3), // 34 days in 2025 (fully used prev year)
          description: '2025 izni',
        ),
        Leave(
          id: 'l1',
          personnelId: 3,
          type: LeaveType.annual,
          startDate: DateTime(2026, 5, 1),
          endDate: DateTime(2026, 6, 9), // 40 days
          description: 'Uzun yıllık izin',
        ),
      ];

      final entitlement = service.calculate(
        personnel: personSenior,
        leaves: leaves,
        targetYear: 2026,
        asOfDate: asOfDate,
      );

      expect(entitlement.seniorityYears, 12);
      expect(entitlement.baseAnnualQuota, 34);
      expect(entitlement.transferredDays, 0);
      expect(entitlement.totalAnnualDays, 34);
      expect(entitlement.usedAnnualDays, 40);
      expect(entitlement.remainingAnnualDays, 0);
      expect(entitlement.usagePercentage, 1.0);
    });

    test('user rule: 2024 unused days do NOT transfer to 2026 (only 2025 transfers)', () {
      final leaves = [
        // 2024: 0 leaves used, so 2024 had 24 days left
        // 2025: 14 days used out of 24 -> 10 days left
        Leave(
          id: 'l2025',
          personnelId: 2,
          type: LeaveType.annual,
          startDate: DateTime(2025, 6, 1),
          endDate: DateTime(2025, 6, 14), // 14 days
          description: '2025',
        ),
      ];

      final entitlement = service.calculate(
        personnel: personMid,
        leaves: leaves,
        targetYear: 2026,
        asOfDate: asOfDate,
      );

      // Only 2025 remaining (10 days) transfers to 2026; 2024 does NOT transfer
      expect(entitlement.transferredDays, 10);
      expect(entitlement.totalAnnualDays, 34); // 24 base + 10 devreden = 34
    });

    test('calculateDaysInYear partitions leave correctly across year boundaries', () {
      final crossYearLeave = Leave(
        id: 'cross',
        personnelId: 2,
        type: LeaveType.annual,
        startDate: DateTime(2025, 12, 30),
        endDate: DateTime(2026, 1, 3), // 5 days total: Dec 30, Dec 31 (2 days) + Jan 1, Jan 2, Jan 3 (3 days)
        description: 'Yılbaşı izni',
      );

      expect(service.calculateDaysInYear(crossYearLeave, 2025), 2);
      expect(service.calculateDaysInYear(crossYearLeave, 2026), 3);
      expect(service.calculateDaysInYear(crossYearLeave, 2027), 0);
    });
  });
}
