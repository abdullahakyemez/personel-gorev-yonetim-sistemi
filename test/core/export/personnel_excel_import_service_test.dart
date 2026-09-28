import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_import_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/work_schedule.dart';

void main() {
  final samplePerson1 = Personnel(
    id: 1,
    registryNumber: '100001',
    fullName: 'Ali Kaya',
    rank: 'Komiser',
    title: 'Grup Amiri',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Cinayet Büro Amirliği',
    phone: '5551112233',
    email: 'ali.kaya@egm.gov.tr',
    address: 'Ankara Çankaya',
    bloodType: '0+',
    relativeName: 'Fatma Kaya',
    relativePhone: '5552223344',
    startDate: DateTime(2021, 5, 10),
    officeStartDate: DateTime(2022, 1, 1),
    endDate: null,
    status: PersonnelStatus.duty,
    workSchedule: WorkSchedule(
      type: WorkScheduleType.twoPlusOne,
      dutyDays: 2,
      restDays: 1,
      startDate: DateTime(2021, 5, 10),
    ),
  );

  final samplePerson2 = Personnel(
    id: 2,
    registryNumber: '100002',
    fullName: 'Mehmet Demir',
    rank: 'Polis Memuru',
    title: 'Büro Memuru',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Hırsızlık Büro Amirliği',
    phone: '5553334455',
    email: 'mehmet.demir@egm.gov.tr',
    address: 'Ankara Keçiören',
    bloodType: 'A+',
    startDate: DateTime(2020, 2, 15),
    status: PersonnelStatus.leave,
  );

  group('PersonnelExcelImportService Tests', () {
    late PersonnelExcelImportService importService;

    setUp(() {
      importService = PersonnelExcelImportService();
    });

    test('generateTemplateBytes creates valid excel template with headers', () {
      final bytes = importService.generateTemplateBytes();
      expect(bytes, isNotNull);
      expect(bytes, isA<Uint8List>());

      final excel = Excel.decodeBytes(bytes!);
      expect(excel.tables.containsKey('Personel_Sablonu'), isTrue);

      final sheet = excel['Personel_Sablonu'];
      expect(sheet.maxRows, greaterThanOrEqualTo(2)); // Header + sample row

      final headers = sheet.rows.first.map((c) => c?.value?.toString()).toList();
      expect(headers, contains('Sicil'));
      expect(headers, contains('Ad Soyad'));
      expect(headers, contains('Rütbe'));
      expect(headers, contains('Göreve Başlama'));
    });

    test('parseExcelBytes successfully imports valid exported personnel bytes', () {
      // Export personnel using existing export service
      final exportService = PersonnelExcelExportService();
      final exportedBytes = exportService.generateExcelBytes(
        personnel: [samplePerson1, samplePerson2],
      );
      expect(exportedBytes, isNotNull);

      // Now import it back
      final analysis = importService.parseExcelBytes(
        bytes: exportedBytes!,
        existingRegistryNumbers: {'100001'}, // samplePerson1 is duplicate in db
      );

      expect(analysis.totalRows, equals(2));
      expect(analysis.validRows.length, equals(2));
      expect(analysis.invalidRows, isEmpty);

      // Check duplicate detection
      expect(analysis.duplicateRows.length, equals(1));
      expect(analysis.duplicateRows.first.personnel?.registryNumber, equals('100001'));
      expect(analysis.newValidRows.length, equals(1));
      expect(analysis.newValidRows.first.personnel?.registryNumber, equals('100002'));

      // Check fields of imported personnel
      final p1 = analysis.validRows.first.personnel!;
      expect(p1.registryNumber, equals('100001'));
      expect(p1.fullName, equals('Ali Kaya'));
      expect(p1.rank, equals('Komiser'));
      expect(p1.department, equals('Asayiş Şube Müdürlüğü'));
      expect(p1.branch, equals('Cinayet Büro Amirliği'));
      expect(p1.phone, equals('5551112233'));
      expect(p1.email, equals('ali.kaya@egm.gov.tr'));
      expect(p1.startDate.year, equals(2021));
      expect(p1.startDate.month, equals(5));
      expect(p1.startDate.day, equals(10));
      expect(p1.status, equals(PersonnelStatus.duty));
      expect(p1.workSchedule?.dutyDays, equals(2));
      expect(p1.workSchedule?.restDays, equals(1));
    });

    test('parseExcelBytes identifies invalid rows with missing required fields', () {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow([
        TextCellValue('Sicil'),
        TextCellValue('Ad Soyad'),
        TextCellValue('Göreve Başlama'),
      ]);

      // Row 2: Empty sicil
      sheet.appendRow([
        TextCellValue(''),
        TextCellValue('Test İsim'),
        TextCellValue('01.01.2024'),
      ]);

      // Row 3: Empty name
      sheet.appendRow([
        TextCellValue('123456'),
        TextCellValue(''),
        TextCellValue('01.01.2024'),
      ]);

      // Row 4: Invalid date
      sheet.appendRow([
        TextCellValue('789012'),
        TextCellValue('Geçersiz Tarih'),
        TextCellValue('bu-bir-tarih-degil'),
      ]);

      // Row 5: Duplicate in file
      sheet.appendRow([
        TextCellValue('123456'), // same as row 3
        TextCellValue('İkinci Kişi'),
        TextCellValue('01.01.2024'),
      ]);

      final bytes = Uint8List.fromList(excel.encode()!);
      final analysis = importService.parseExcelBytes(
        bytes: bytes,
        existingRegistryNumbers: {},
      );

      expect(analysis.totalRows, equals(4));
      expect(analysis.invalidRows.length, equals(4));
      expect(analysis.validRows, isEmpty);

      // Verify specific errors
      expect(analysis.allRows[0].errors.any((e) => e.contains('Sicil')), isTrue);
      expect(analysis.allRows[1].errors.any((e) => e.contains('Ad Soyad')), isTrue);
      expect(analysis.allRows[2].errors.any((e) => e.contains('tarih')), isTrue);
      expect(analysis.allRows[3].errors.any((e) => e.contains('mükerrer')), isTrue);
    });
  });
}
