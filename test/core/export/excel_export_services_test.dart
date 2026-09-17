import 'dart:typed_data';
import 'package:excel_plus/excel_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_report_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_report_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/work_schedule.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

void main() {
  final samplePerson = Personnel(
    id: 1,
    registryNumber: '12345',
    fullName: 'Ahmet Yılmaz',
    rank: 'Polis Memuru',
    title: 'Memur',
    department: 'Asayiş',
    branch: 'Devriye',
    phone: '5551112233',
    email: 'ahmet@example.com',
    address: 'Ankara',
    startDate: DateTime(2020, 1, 1),
    status: PersonnelStatus.duty,
    workSchedule: WorkSchedule(
      type: WorkScheduleType.twoPlusOne,
      dutyDays: 2,
      restDays: 1,
      startDate: DateTime(2025, 9, 1),
    ),
  );

  final sampleLeave = Leave(
    id: 'leave-1',
    personnelId: 1,
    type: LeaveType.annual,
    startDate: DateTime(2025, 10, 1),
    endDate: DateTime(2025, 10, 5),
    description: 'Yıllık izin',
    address: 'İzmir',
  );

  final sampleReport = Leave(
    id: 'leave-2',
    personnelId: 1,
    type: LeaveType.report,
    startDate: DateTime(2025, 11, 1),
    endDate: DateTime(2025, 11, 3),
    description: 'İstirahat raporu',
    address: 'Ankara',
  );

  final sampleTask = Task(
    id: 'task-1',
    title: 'Sınav Tedbiri',
    description: 'Bölge kontrolü',
    startDate: DateTime(2025, 10, 1),
    endDate: DateTime(2025, 10, 2),
    status: TaskStatus.completed,
    personnelIds: [1],
  );

  group('LeaveReportExportService Excel Tests', () {
    test('generateExcelBytes generates valid excel with summary and period sheets', () {
      final service = LeaveReportExportService();
      final bytes = service.generateExcelBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        personnel: [samplePerson],
        leaves: [sampleLeave, sampleReport],
      );

      expect(bytes, isNotNull);
      expect(bytes, isA<Uint8List>());

      final excel = Excel.decodeBytes(bytes!);
      expect(excel.sheets.containsKey('Özet'), isTrue);
      expect(excel.sheets.containsKey('2025-2026'), isTrue);

      final periodSheet = excel['2025-2026'];
      expect(periodSheet.maxRows, greaterThanOrEqualTo(3));
    });

    test('generateExcelBytes handles empty leaves gracefully', () {
      final service = LeaveReportExportService();
      final bytes = service.generateExcelBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        personnel: [samplePerson],
        leaves: [],
      );

      expect(bytes, isNotNull);
      final excel = Excel.decodeBytes(bytes!);
      expect(excel.sheets.containsKey('Özet'), isTrue);
    });
  });

  group('PersonnelReportExportService Excel Tests', () {
    test('generateExcelBytes generates sheets with safe names <= 31 chars', () {
      final service = PersonnelReportExportService();
      final bytes = service.generateExcelBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        person: samplePerson,
        tasks: [sampleTask],
        leaves: [sampleLeave, sampleReport],
      );

      expect(bytes, isNotNull);
      final excel = Excel.decodeBytes(bytes!);
      expect(excel.sheets.containsKey('Personel Bilgileri'), isTrue);

      for (final sheetName in excel.sheets.keys) {
        expect(sheetName.length, lessThanOrEqualTo(31));
        expect(sheetName.contains(RegExp(r'[\\/*?:\[\]]')), isFalse);
      }
    });

    test('generateExcelBytes handles empty tasks and leaves gracefully', () {
      final service = PersonnelReportExportService();
      final bytes = service.generateExcelBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        person: samplePerson,
        tasks: [],
        leaves: [],
      );

      expect(bytes, isNotNull);
      final excel = Excel.decodeBytes(bytes!);
      expect(excel.sheets.containsKey('Personel Bilgileri'), isTrue);
    });
  });

  group('PersonnelExcelExportService Excel Tests', () {
    test('generateExcelBytes exports all headers and rows accurately', () {
      final service = PersonnelExcelExportService();
      final bytes = service.generateExcelBytes(personnel: [samplePerson]);

      expect(bytes, isNotNull);
      final excel = Excel.decodeBytes(bytes!);
      expect(excel.sheets.containsKey('Personeller'), isTrue);

      final sheet = excel['Personeller'];
      expect(sheet.maxRows, equals(2));
      final firstRow = sheet.rows.first;
      expect(firstRow.length, equals(16));
    });

    test('generateExcelBytes handles empty list with headers only', () {
      final service = PersonnelExcelExportService();
      final bytes = service.generateExcelBytes(personnel: []);

      expect(bytes, isNotNull);
      final excel = Excel.decodeBytes(bytes!);
      final sheet = excel['Personeller'];
      expect(sheet.maxRows, equals(1));
    });
  });
}
