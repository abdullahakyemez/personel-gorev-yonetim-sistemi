import 'package:excel_plus/excel_plus.dart';

import '../../features/personnel/domain/models/personnel.dart';
import 'export_file_service.dart';

class PersonnelExcelExportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  Future<String?> export({required List<Personnel> personnel}) async {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Personeller');
    final sheet = excel['Personeller'];

    final headers = [
      'Sicil',
      'Ad Soyad',
      'Rütbe',
      'Ünvan',
      'Şube',
      'Büro',
      'Telefon',
      'E-posta',
      'Adres',
      'Kan Grubu',
      'Yakın Adı',
      'Yakın Telefonu',
      'Çalışma Düzeni',
      'Göreve Başlama',
      'Görevden Ayrılma',
      'Durum',
    ];

    sheet.appendRow(headers.map(TextCellValue.new).toList());

    for (final person in personnel) {
      sheet.appendRow([
        TextCellValue(person.registryNumber),
        TextCellValue(person.fullName),
        TextCellValue(person.rank),
        TextCellValue(person.title),
        TextCellValue(person.department),
        TextCellValue(person.branch),
        TextCellValue(person.phone),
        TextCellValue(person.email),
        TextCellValue(person.address),
        TextCellValue(person.bloodType ?? '-'),
        TextCellValue(person.relativeName ?? '-'),
        TextCellValue(person.relativePhone ?? '-'),
        TextCellValue(person.workSchedule?.label ?? '-'),
        TextCellValue(_date(person.startDate)),
        TextCellValue(person.endDate == null ? '-' : _date(person.endDate!)),
        TextCellValue(_status(person.status)),
      ]);
    }

    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    final bytes = excel.encode();
    if (bytes == null) return null;

    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName: 'Personeller.xlsx',
      extension: 'xlsx',
      mimeType: _mimeType,
    );
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  String _status(PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return 'Görevde';
      case PersonnelStatus.resting:
        return 'İstirahatli';
      case PersonnelStatus.leave:
        return 'İzinli';
      case PersonnelStatus.sickReport:
        return 'Raporlu';
    }
  }
}
