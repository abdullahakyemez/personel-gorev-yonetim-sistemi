import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';

import '../../features/leave/domain/extensions/leave_type_extension.dart';
import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import '../../features/task/domain/extensions/task_category_extension.dart';
import '../../features/task/domain/extensions/task_status_extension.dart';
import '../../features/task/domain/models/task.dart';
import 'export_file_service.dart';
import 'report_export_data.dart';

class PersonnelReportExportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  /// Generates the raw Excel bytes for an individual personnel report.
  /// Decoupled from file saving to enable headless testing and flexible storage.
  Uint8List? generateExcelBytes({
    required DateTime startDate,
    required DateTime endDate,
    required Personnel person,
    required List<Task> tasks,
    required List<Leave> leaves,
  }) {
    final data = ReportExportData(
      startDate: startDate,
      endDate: endDate,
      personnel: [person],
      leaves: leaves,
      tasks: tasks,
    );

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Personel Bilgileri');
    final info = excel['Personel Bilgileri'];

    _row(info, ['PERSONEL RAPORU']);
    _row(info, ['Rapor Tarih Aralığı', _period(startDate, endDate)]);
    _row(info, ['Sicil', person.registryNumber]);
    _row(info, ['Ad Soyad', person.fullName]);
    _row(info, ['Rütbe', person.rank]);
    _row(info, ['Ünvan', person.title]);
    _row(info, ['Şube', person.department]);
    _row(info, ['Büro', person.branch]);
    _row(info, ['Telefon', person.phone]);
    _row(info, ['E-posta', person.email]);
    _row(info, ['Adres', person.address]);
    _row(info, ['Kan Grubu', person.bloodType ?? '-']);
    _row(info, ['Yakın Adı', person.relativeName ?? '-']);
    _row(info, ['Yakın Telefonu', person.relativePhone ?? '-']);
    _row(info, ['Çalışma Düzeni', person.workSchedule?.label ?? '-']);
    _row(info, ['Göreve Başlama Tarihi', _date(person.startDate)]);
    _row(info, ['Büroya Başlama Tarihi', person.officeStartDate != null ? _date(person.officeStartDate!) : '-']);

    for (final period in data.periods) {
      final periodStart = period.start.isAfter(startDate) ? period.start : startDate;
      final periodEnd = period.end.isBefore(endDate) ? period.end : endDate;
      final suffix = '${period.start.year}-${period.end.year}';

      _writeTasks(excel, suffix, data, person, periodStart, periodEnd);
      _writeLeaves(excel, '$suffix İzinler', data, person, periodStart, periodEnd);
      _writeReports(excel, '$suffix Raporlar', data, person, periodStart, periodEnd);
    }

    final bytes = excel.encode();
    if (bytes == null) return null;
    return Uint8List.fromList(bytes);
  }

  Future<String?> exportExcel({
    required DateTime startDate,
    required DateTime endDate,
    required Personnel person,
    required List<Task> tasks,
    required List<Leave> leaves,
  }) async {
    final bytes = generateExcelBytes(
      startDate: startDate,
      endDate: endDate,
      person: person,
      tasks: tasks,
      leaves: leaves,
    );
    if (bytes == null) return null;

    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName:
          '${_safeFile(person.fullName)}_Personel_Raporu_${_fileDate(startDate)}_${_fileDate(endDate)}.xlsx',
      extension: 'xlsx',
      mimeType: _mimeType,
    );
  }

  void _writeTasks(
    Excel excel,
    String suffix,
    ReportExportData data,
    Personnel person,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    final sheet = excel[_safeSheet('$suffix Görevler')];
    _row(sheet, ['Çalışma Dönemi', suffix]);
    _row(sheet, ['Tür', 'Başlangıç', 'Bitiş', 'Durum', 'Açıklama']);

    final rows = data.tasks.where((task) {
      return person.id != null &&
          task.personnelIds.contains(person.id) &&
          data.overlaps(task.startDate, task.endDate, periodStart, periodEnd);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (final task in rows) {
      _row(sheet, [
        task.category?.label ?? task.title,
        _date(task.startDate),
        _date(task.endDate),
        task.status.label,
        task.description,
      ]);
    }

    _fit(sheet, 5);
  }

  void _writeLeaves(
    Excel excel,
    String sheetName,
    ReportExportData data,
    Personnel person,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    final sheet = excel[_safeSheet(sheetName)];
    _row(sheet, ['Çalışma Dönemi', sheetName.replaceFirst(' İzinler', '')]);
    _row(sheet, ['İzin Türü', 'Başlangıç', 'Bitiş', 'Gün', 'Açıklama']);

    final rows = data.leaves.where((leave) {
      return leave.personnelId == person.id &&
          leave.type != LeaveType.report &&
          data.overlaps(leave.startDate, leave.endDate, periodStart, periodEnd);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (final leave in rows) {
      _row(sheet, [
        leave.type.label,
        _date(leave.startDate),
        _date(leave.endDate),
        data.clippedDays(leave.startDate, leave.endDate, periodStart, periodEnd),
        leave.description,
      ]);
    }

    _fit(sheet, 5);
  }

  void _writeReports(
    Excel excel,
    String sheetName,
    ReportExportData data,
    Personnel person,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    final sheet = excel[_safeSheet(sheetName)];
    _row(sheet, ['Çalışma Dönemi', sheetName.replaceFirst(' Raporlar', '')]);
    _row(sheet, ['Başlangıç', 'Bitiş', 'Gün', 'Açıklama']);

    final rows = data.leaves.where((leave) {
      return leave.personnelId == person.id &&
          leave.type == LeaveType.report &&
          data.overlaps(leave.startDate, leave.endDate, periodStart, periodEnd);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (final leave in rows) {
      _row(sheet, [
        _date(leave.startDate),
        _date(leave.endDate),
        data.clippedDays(leave.startDate, leave.endDate, periodStart, periodEnd),
        leave.description,
      ]);
    }

    _fit(sheet, 4);
  }

  void _row(Sheet sheet, List<Object?> values) {
    sheet.appendRow(values.map((value) {
      if (value is int) return IntCellValue(value);
      if (value is double) return DoubleCellValue(value);
      return TextCellValue(value?.toString() ?? '');
    }).toList());
  }

  void _fit(Sheet sheet, int count) {
    for (var i = 0; i < count; i++) {
      sheet.setColumnAutoFit(i);
    }
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  String _fileDate(DateTime value) =>
      '${value.year}${value.month.toString().padLeft(2, '0')}${value.day.toString().padLeft(2, '0')}';

  String _period(DateTime start, DateTime end) => '${_date(start)} - ${_date(end)}';

  String _safeFile(String value) => value
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
      .trim();

  String _safeSheet(String value) {
    final cleaned = value.replaceAll(RegExp(r'[\\/*?:\[\]]'), '_');
    return cleaned.length > 31 ? cleaned.substring(0, 31) : cleaned;
  }
}
