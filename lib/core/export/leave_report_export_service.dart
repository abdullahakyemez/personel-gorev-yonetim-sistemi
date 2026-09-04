import 'package:excel_plus/excel_plus.dart';

import '../../features/leave/domain/extensions/leave_type_extension.dart';
import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import 'export_file_service.dart';
import 'report_export_data.dart';
import '../utils/work_year.dart';

class LeaveReportExportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  Future<String?> exportExcel({
    required DateTime startDate,
    required DateTime endDate,
    required List<Personnel> personnel,
    required List<Leave> leaves,
  }) async {
    final data = ReportExportData(
      startDate: startDate,
      endDate: endDate,
      personnel: personnel,
      leaves: leaves,
      tasks: const [],
    );

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Özet');
    final summary = excel['Özet'];

    _row(summary, ['İZİN VE RAPOR RAPORU']);
    _row(summary, ['Rapor Tarih Aralığı', _period(startDate, endDate)]);
    _row(summary, ['Çalışma Dönemleri', data.periods.map((e) => e.label).join(' | ')]);
    _row(summary, ['Toplam Kayıt', _filteredLeaves(data).length]);
    _row(summary, ['Yıllık İzin Kayıt', _countType(data, LeaveType.annual)]);
    _row(summary, ['Mazeret İzni Kayıt', _countType(data, LeaveType.excuse)]);
    _row(summary, ['Rapor Kayıt', _countType(data, LeaveType.report)]);

    for (final period in data.periods) {
      _writePeriodSheet(excel, data, period);
    }

    final bytes = excel.encode();
    if (bytes == null) return null;

    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName:
          'Izin_Raporu_${_fileDate(startDate)}_${_fileDate(endDate)}.xlsx',
      extension: 'xlsx',
      mimeType: _mimeType,
    );
  }

  void _writePeriodSheet(
    Excel excel,
    ReportExportData data,
    WorkYearPeriod period,
  ) {
    final sheet = excel[_safeSheet('${period.start.year}-${period.end.year}')];
    _row(sheet, ['Çalışma Dönemi', period.label]);
    _row(sheet, [
      'İzin/Rapor',
      'Sicil',
      'Personel',
      'Rütbe',
      'Büro',
      'Başlangıç',
      'Bitiş',
      'Gün',
      'Açıklama',
    ]);

    final periodStart = period.start.isAfter(data.startDate)
        ? period.start
        : data.startDate;
    final periodEnd = period.end.isBefore(data.endDate)
        ? period.end
        : data.endDate;

    final personnelByRegistry = {
      for (final person in data.personnel) person.registryNumber: person,
    };

    final rows = data.leaves.where((leave) {
      return leaveEndAfterFilter(leave, periodStart, periodEnd);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (final leave in rows) {
      _row(sheet, [
        leave.type.label,
        leave.personnelId,
        personnelByRegistry[leave.personnelId]?.fullName ?? '-',
        personnelByRegistry[leave.personnelId]?.rank ?? '-',
        personnelByRegistry[leave.personnelId]?.branch ?? '-',
        _date(leave.startDate),
        _date(leave.endDate),
        data.clippedDays(leave.startDate, leave.endDate, periodStart, periodEnd),
        leave.description,
      ]);
    }

    for (var i = 0; i < 9; i++) {
      sheet.setColumnAutoFit(i);
    }
  }

  bool leaveEndAfterFilter(
    Leave leave,
    DateTime startDate,
    DateTime endDate,
  ) {
    return !DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day)
            .isBefore(DateTime(startDate.year, startDate.month, startDate.day)) &&
        !DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day)
            .isAfter(DateTime(endDate.year, endDate.month, endDate.day));
  }

  List<Leave> _filteredLeaves(ReportExportData data) {
    return data.leaves.where((leave) => data.overlaps(
      leave.startDate,
      leave.endDate,
      data.startDate,
      data.endDate,
    )).toList();
  }

  int _countType(ReportExportData data, LeaveType type) =>
      _filteredLeaves(data).where((leave) => leave.type == type).length;

  void _row(Sheet sheet, List<Object?> values) {
    sheet.appendRow(values.map((value) {
      if (value is int) return IntCellValue(value);
      if (value is double) return DoubleCellValue(value);
      return TextCellValue('${value ?? ''}');
    }).toList());
  }

  String _period(DateTime start, DateTime end) => '${_date(start)} - ${_date(end)}';

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  String _fileDate(DateTime value) =>
      '${value.year}${value.month.toString().padLeft(2, '0')}${value.day.toString().padLeft(2, '0')}';

  String _safeSheet(String value) {
    final cleaned = value.replaceAll(RegExp(r'[\\/*?:\[\]]'), '_');
    return cleaned.length > 31 ? cleaned.substring(0, 31) : cleaned;
  }
}
