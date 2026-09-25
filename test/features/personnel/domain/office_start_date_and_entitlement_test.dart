import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/services/leave_entitlement_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/forms/person_form_controller.dart';

void main() {
  group('OfficeStartDate and LeaveEntitlement Independence Tests', () {
    const entitlementService = LeaveEntitlementService();

    test('Leave entitlement uses startDate (meslek kıdemi), NOT officeStartDate', () {
      final now = DateTime(2026, 9, 25);
      // Mesleğe 12 yıl önce başlamış (kıdem >= 10 yıl -> 34 gün hak ediş)
      // Büroya ise sadece 2 ay önce başlamış
      final seniorPerson = Personnel(
        id: 1,
        registryNumber: 'SICIL001',
        fullName: 'Ahmet Kıdemli',
        rank: 'Başkomiser',
        title: 'Büro Amiri',
        branch: 'Asayiş',
        department: 'Cinayet Büro',
        startDate: DateTime(2014, 1, 15),
        officeStartDate: DateTime(2026, 7, 1),
        phone: '5551112233',
        email: 'ahmet@pgys.gov.tr',
        address: 'Adres',
        status: PersonnelStatus.duty,
      );

      final entitlement = entitlementService.calculate(
        personnel: seniorPerson,
        leaves: [],
        asOfDate: now,
      );

      // Göreve başlama tarihi 2014 olduğu için kıdem 12 yıldır
      expect(entitlement.seniorityYears, equals(12));
      // 10 yıl ve üzeri olduğu için hak ediş 34 gündür (büroya yeni başlamış olsa bile)
      expect(entitlement.baseAnnualQuota, equals(34));

      // Devir hesabı olmadan kontrol
      final noCarryover = entitlementService.calculate(
        personnel: seniorPerson,
        leaves: [],
        asOfDate: now,
        enableCarryover: false,
      );
      expect(noCarryover.remainingAnnualDays, equals(34));
    });

    test('1-10 years seniority (not yet 10 completed years) receives 24 days quota', () {
      final now = DateTime(2026, 9, 25);
      // Mesleğe 5 yıl önce başlamış
      final midPerson = Personnel(
        id: 2,
        registryNumber: 'SICIL002',
        fullName: 'Mehmet Memur',
        rank: 'Polis Memuru',
        title: 'Ekip Personeli',
        branch: 'Asayiş',
        department: 'Devriye Büro',
        startDate: DateTime(2021, 5, 10),
        officeStartDate: DateTime(2026, 1, 1),
        phone: '5552223344',
        email: 'mehmet@pgys.gov.tr',
        address: 'Adres',
        status: PersonnelStatus.duty,
      );

      final entitlement = entitlementService.calculate(
        personnel: midPerson,
        leaves: [],
        asOfDate: now,
      );

      expect(entitlement.seniorityYears, equals(5));
      expect(entitlement.baseAnnualQuota, equals(24));

      final noCarryover = entitlementService.calculate(
        personnel: midPerson,
        leaves: [],
        asOfDate: now,
        enableCarryover: false,
      );
      expect(noCarryover.remainingAnnualDays, equals(24));
    });

    test('PersonFormController correctly handles officeStartDate', () {
      final controller = PersonFormController();

      // Initial state is null
      expect(controller.officeStartDate, isNull);

      final officeDate = DateTime(2026, 3, 15);
      controller.setOfficeStartDate(officeDate);
      expect(controller.officeStartDate, equals(officeDate));

      // Test load personnel with officeStartDate
      final testPerson = Personnel(
        id: 99,
        registryNumber: '99999',
        fullName: 'Test Personel',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Trafik',
        department: 'Tescil',
        startDate: DateTime(2018, 2, 1),
        officeStartDate: DateTime(2025, 6, 1),
        endDate: DateTime(2028, 1, 1),
        phone: '5550000000',
        email: 'test@pgys.gov.tr',
        address: 'Adres test',
        status: PersonnelStatus.duty,
      );

      controller.load(testPerson);
      expect(controller.officeStartDate, equals(DateTime(2025, 6, 1)));
      expect(controller.startDate, equals(DateTime(2018, 2, 1)));
      expect(controller.endDate, equals(DateTime(2028, 1, 1)));
      expect(controller.isDateRangeValid, isTrue);

      final built = controller.buildPersonnel();
      expect(built.officeStartDate, equals(DateTime(2025, 6, 1)));
      expect(built.startDate, equals(DateTime(2018, 2, 1)));

      controller.clear();
      expect(controller.officeStartDate, isNull);
      expect(controller.startDate, isNull);
    });
  });
}
