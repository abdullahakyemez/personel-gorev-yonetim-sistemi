import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/validators.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

void main() {
  group('Validators Unit Tests', () {
    group('requiredField', () {
      test('Returns error when value is null or empty', () {
        expect(Validators.requiredField(null), isNotNull);
        expect(Validators.requiredField(''), isNotNull);
        expect(Validators.requiredField('   '), isNotNull);
      });

      test('Includes field name in error message when provided', () {
        expect(
          Validators.requiredField(null, 'Ad Soyad'),
          equals('Ad Soyad alanı zorunludur.'),
        );
      });

      test('Returns null when value is non-empty', () {
        expect(Validators.requiredField('Ahmet'), isNull);
      });
    });

    group('email', () {
      test('Returns null for valid emails', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('ahmet.yilmaz@kurum.gov.tr'), isNull);
        expect(Validators.email('user+tag@domain.co'), isNull);
      });

      test('Returns error for invalid emails', () {
        expect(Validators.email('plainaddress'), isNotNull);
        expect(Validators.email('missingatsign.com'), isNotNull);
        expect(Validators.email('@nodomain.com'), isNotNull);
        expect(Validators.email('trailingat@'), isNotNull);
      });

      test('Handles empty and required flags correctly', () {
        expect(Validators.email('', required: false), isNull);
        expect(Validators.email(null, required: false), isNull);
        expect(Validators.email('', required: true), isNotNull);
        expect(Validators.email(null, required: true), isNotNull);
      });
    });

    group('phone', () {
      test('Returns null for valid phone numbers (10 or 11 digits)', () {
        expect(Validators.phone('05551234567'), isNull);
        expect(Validators.phone('5551234567'), isNull);
        expect(Validators.phone('0 (555) 123 45 67'), isNull);
        expect(Validators.phone('+90 555 123 45 67'), isNull);
      });

      test('Returns error for invalid phone numbers', () {
        expect(Validators.phone('123'), isNotNull);
        expect(Validators.phone('123456789'), isNotNull); // 9 digits
        expect(Validators.phone('1234567890123'), isNotNull); // 13 digits
      });

      test('Handles empty and required flags correctly', () {
        expect(Validators.phone('', required: false), isNull);
        expect(Validators.phone(null, required: false), isNull);
        expect(Validators.phone('', required: true), isNotNull);
        expect(Validators.phone(null, required: true), isNotNull);
      });
    });

    group('registryNumber', () {
      final existing = <Personnel>[
        Personnel(
          id: 1,
          registryNumber: '10001',
          fullName: 'Ahmet Yılmaz',
          rank: 'Memur',
          title: 'Büro Personeli',
          branch: 'İdari İşler',
          department: 'Yönetim',
          status: PersonnelStatus.duty,
          startDate: DateTime(2025, 1, 1),
          phone: '05551234567',
          email: 'ahmet@example.com',
          address: 'Adres',
        ),
        Personnel(
          id: 2,
          registryNumber: '10002',
          fullName: 'Mehmet Demir',
          rank: 'Memur',
          title: 'Büro Personeli',
          branch: 'İdari İşler',
          department: 'Yönetim',
          status: PersonnelStatus.duty,
          startDate: DateTime(2025, 1, 1),
          phone: '05559876543',
          email: 'mehmet@example.com',
          address: 'Adres',
        ),
      ];

      test('Returns error when empty', () {
        expect(
          Validators.registryNumber('', existingPersonnel: existing),
          isNotNull,
        );
      });

      test('Detects duplicate registry number for new personnel', () {
        final error = Validators.registryNumber(
          '10001',
          existingPersonnel: existing,
        );
        expect(error, contains('başka bir personele aittir'));
      });

      test('Allows same registry number when editing same personnel', () {
        final error = Validators.registryNumber(
          '10001',
          existingPersonnel: existing,
          currentPersonnelId: 1,
        );
        expect(error, isNull);
      });

      test('Prevents editing to another existing personnel registry number', () {
        final error = Validators.registryNumber(
          '10002',
          existingPersonnel: existing,
          currentPersonnelId: 1, // Personnel 1 trying to take Personnel 2's registry
        );
        expect(error, isNotNull);
      });

      test('Allows unique new registry number', () {
        final error = Validators.registryNumber(
          '10003',
          existingPersonnel: existing,
        );
        expect(error, isNull);
      });
    });

    group('dateOrder', () {
      test('Returns null when end date is after start date', () {
        final error = Validators.dateOrder(
          DateTime(2026, 6, 1),
          DateTime(2026, 6, 5),
        );
        expect(error, isNull);
      });

      test('Returns null when start and end dates are same day', () {
        final error = Validators.dateOrder(
          DateTime(2026, 6, 1, 15, 0),
          DateTime(2026, 6, 1, 9, 0),
        );
        expect(error, isNull);
      });

      test('Returns error when end date is before start date', () {
        final error = Validators.dateOrder(
          DateTime(2026, 6, 5),
          DateTime(2026, 6, 1),
        );
        expect(error, equals('Bitiş tarihi, başlangıç tarihinden önce olamaz.'));
      });

      test('Uses custom error message when provided', () {
        final error = Validators.dateOrder(
          DateTime(2026, 6, 5),
          DateTime(2026, 6, 1),
          'Ayrılış tarihi hatalı.',
        );
        expect(error, equals('Ayrılış tarihi hatalı.'));
      });

      test('Returns null if either date is null', () {
        expect(Validators.dateOrder(null, DateTime(2026, 6, 1)), isNull);
        expect(Validators.dateOrder(DateTime(2026, 6, 1), null), isNull);
        expect(Validators.dateOrder(null, null), isNull);
      });
    });
  });
}
