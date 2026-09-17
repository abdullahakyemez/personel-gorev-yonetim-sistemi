import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/report_pdf_export_service.dart';
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

  group('ReportPdfExportService Tests', () {
    test('generateLeavePdfBytes produces valid PDF bytes (%PDF- header)', () async {
      final bytes = await ReportPdfExportService.generateLeavePdfBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        personnel: [samplePerson],
        leaves: [sampleLeave, sampleReport],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(100));

      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('generateLeavePdfBytes handles empty leaves without crashing', () async {
      final bytes = await ReportPdfExportService.generateLeavePdfBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        personnel: [samplePerson],
        leaves: [],
      );

      expect(bytes, isNotEmpty);
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('generateLeavePdfBytes handles invalid/reversed date range gracefully', () async {
      final bytes = await ReportPdfExportService.generateLeavePdfBytes(
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2025, 8, 31),
        personnel: [samplePerson],
        leaves: [sampleLeave],
      );

      expect(bytes, isNotEmpty);
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('generatePersonnelPdfBytes produces valid PDF bytes (%PDF- header)', () async {
      final bytes = await ReportPdfExportService.generatePersonnelPdfBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        person: samplePerson,
        tasks: [sampleTask],
        leaves: [sampleLeave, sampleReport],
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(100));

      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('generatePersonnelPdfBytes handles empty tasks and leaves without crashing', () async {
      final bytes = await ReportPdfExportService.generatePersonnelPdfBytes(
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2026, 8, 31),
        person: samplePerson,
        tasks: [],
        leaves: [],
      );

      expect(bytes, isNotEmpty);
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });
  });
}
