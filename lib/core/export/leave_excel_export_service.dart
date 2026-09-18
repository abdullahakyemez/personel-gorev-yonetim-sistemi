import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';

import '../../features/leave/domain/extensions/leave_type_extension.dart';
import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import 'export_file_service.dart';

class LeaveExcelExportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  static String formatLeaveRecordNo(Leave leave) {
    final prefix = switch (leave.type) {
      LeaveType.annual => 'IZN',
      LeaveType.excuse => 'MAZ',
      LeaveType.report => 'RAP',
    };
    final year = leave.startDate.year;
    final numeric = leave.id.replaceAll(RegExp(r'\D'), '');
    final numStr = numeric.length >= 4
        ? numeric.substring(numeric.length - 4)
        : (numeric.isNotEmpty ? numeric.padLeft(4, '0') : '0001');
    return '$prefix-$year-$numStr';
  }

  Uint8List? generateExcelBytes({
    required List<Leave> leaves,
    required List<Personnel> personnel,
  }) {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'İzinler');
    final sheet = excel['İzinler'];

    final headers = [
      'Kayıt No',
      'Sicil',
      'Ad Soyad',
      'Rütbe',
      'İzin / Rapor Türü',
      'Başlangıç Tarihi',
      'Bitiş Tarihi',
      'Gün',
      'İkametgah / Adres',
      'Açıklama',
    ];

    sheet.appendRow(headers.map(TextCellValue.new).toList());

    final personnelMap = {
      for (final p in personnel)
        if (p.id != null) p.id!: p,
    };

    for (final leave in leaves) {
      final person = personnelMap[leave.personnelId];
      final recordNo = formatLeaveRecordNo(leave);

      sheet.appendRow([
        TextCellValue(recordNo),
        TextCellValue(person?.registryNumber ?? '-'),
        TextCellValue(person?.fullName ?? '-'),
        TextCellValue(person?.rank ?? '-'),
        TextCellValue(leave.type.label),
        TextCellValue(_date(leave.startDate)),
        TextCellValue(_date(leave.endDate)),
        IntCellValue(leave.dayCount),
        TextCellValue(person?.address ?? '-'),
        TextCellValue(leave.description),
      ]);
    }

    return Uint8List.fromList(excel.encode() ?? []);
  }

  Future<void> exportAndSave({
    required List<Leave> leaves,
    required List<Personnel> personnel,
  }) async {
    final bytes = generateExcelBytes(leaves: leaves, personnel: personnel);
    if (bytes == null || bytes.isEmpty) return;

    final now = DateTime.now();
    final fileName =
        'izinler_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.xlsx';

    await ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName: fileName,
      extension: 'xlsx',
      mimeType: _mimeType,
    );
  }

  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
