import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';

import '../../features/personnel/domain/models/personnel.dart';
import '../../features/personnel/domain/models/work_schedule.dart';
import 'export_file_service.dart';

class PersonnelImportRow {
  final int rowNumber;
  final Personnel? personnel;
  final List<String> errors;
  final bool isDuplicate;

  const PersonnelImportRow({
    required this.rowNumber,
    required this.personnel,
    required this.errors,
    required this.isDuplicate,
  });

  bool get isValid => errors.isEmpty && personnel != null;
}

class PersonnelImportAnalysis {
  final int totalRows;
  final List<PersonnelImportRow> allRows;

  const PersonnelImportAnalysis({
    required this.totalRows,
    required this.allRows,
  });

  List<PersonnelImportRow> get validRows =>
      allRows.where((r) => r.isValid).toList();

  List<PersonnelImportRow> get invalidRows =>
      allRows.where((r) => !r.isValid).toList();

  List<PersonnelImportRow> get duplicateRows =>
      allRows.where((r) => r.isValid && r.isDuplicate).toList();

  List<PersonnelImportRow> get newValidRows =>
      allRows.where((r) => r.isValid && !r.isDuplicate).toList();
}

class PersonnelExcelImportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  static const List<String> standardHeaders = [
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
    'Büroya Başlama',
    'Görevden Ayrılma',
    'Durum',
  ];

  /// Toplu personel ekleme için kullanıcının dolduracağı boş/örnek Excel şablonu üretir.
  Uint8List? generateTemplateBytes() {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Personel_Sablonu');
    final sheet = excel['Personel_Sablonu'];

    sheet.appendRow(standardHeaders.map(TextCellValue.new).toList());

    // Rehberlik için bir örnek satır ekleyelim
    sheet.appendRow([
      TextCellValue('430558'),
      TextCellValue('Ahmet YILMAZ'),
      TextCellValue('Polis Memuru'),
      TextCellValue('Büro Memuru'),
      TextCellValue('Asayiş Şube Müdürlüğü'),
      TextCellValue('Hırsızlık Büro Amirliği'),
      TextCellValue('5551234567'),
      TextCellValue('ahmet.yilmaz@egm.gov.tr'),
      TextCellValue('Ankara'),
      TextCellValue('A+'),
      TextCellValue('Ayşe Yılmaz'),
      TextCellValue('5559876543'),
      TextCellValue('2+1'),
      TextCellValue('01.01.2024'),
      TextCellValue('15.01.2024'),
      TextCellValue(''),
      TextCellValue('Görevde'),
    ]);

    for (var i = 0; i < standardHeaders.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    final bytes = excel.encode();
    if (bytes == null) return null;
    return Uint8List.fromList(bytes);
  }

  /// Örnek Excel şablonunu kullanıcının bilgisayarına kaydeder.
  Future<String?> exportTemplateAndSave() async {
    final bytes = generateTemplateBytes();
    if (bytes == null) return null;

    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName: 'Personel_Yukleme_Sablonu.xlsx',
      extension: 'xlsx',
      mimeType: _mimeType,
      dialogTitle: 'Şablonu Kaydet',
    );
  }

  /// Verilen Excel dosya baytlarını ayrıştırır ve doğrulama analizini döndürür.
  PersonnelImportAnalysis parseExcelBytes({
    required Uint8List bytes,
    required Set<String> existingRegistryNumbers,
  }) {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      return const PersonnelImportAnalysis(totalRows: 0, allRows: []);
    }

    // İlk dolu sayfayı veya 'Personeller' / 'Personel_Sablonu' sayfasını seç
    Sheet? targetSheet;
    for (final sheetName in ['Personeller', 'Personel_Sablonu', 'Sheet1']) {
      if (excel.tables.containsKey(sheetName) &&
          excel.tables[sheetName]!.maxRows > 0) {
        targetSheet = excel.tables[sheetName];
        break;
      }
    }
    targetSheet ??= excel.tables.values.first;

    final rows = targetSheet.rows;
    if (rows.isEmpty) {
      return const PersonnelImportAnalysis(totalRows: 0, allRows: []);
    }

    // İlk satırı başlık olarak oku
    final headerRow = rows.first;
    final columnMap = _buildColumnMap(headerRow);

    final allRows = <PersonnelImportRow>[];
    final seenRegistryNumbersInFile = <String>{};

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (_isRowEmpty(row)) continue;

      final rowErrors = <String>[];
      final rowNum = i + 1; // 1-indexed (Excel satır numarası)

      final registryNumber = _extractCell(row, columnMap, ['sicil', 'sicil no', 'sicil no.', 'registry', 'registry number']);
      final fullName = _extractCell(row, columnMap, ['ad soyad', 'ad', 'soyad', 'adı soyadı', 'fullname', 'name']);
      final rank = _extractCell(row, columnMap, ['rütbe', 'rutbe', 'rank']);
      final title = _extractCell(row, columnMap, ['ünvan', 'unvan', 'title']);
      final department = _extractCell(row, columnMap, ['şube', 'sube', 'şube müdürlüğü', 'birim', 'department']);
      final branch = _extractCell(row, columnMap, ['büro', 'buro', 'büro amirliği', 'branch']);
      final phone = _extractCell(row, columnMap, ['telefon', 'tel', 'gsm', 'phone']);
      final email = _extractCell(row, columnMap, ['e-posta', 'eposta', 'email', 'mail']);
      final address = _extractCell(row, columnMap, ['adres', 'address']);

      final bloodType = _extractCell(row, columnMap, ['kan grubu', 'kangrubu', 'blood']);
      final relativeName = _extractCell(row, columnMap, ['yakın adı', 'yakın', 'yakin adi', 'relative name']);
      final relativePhone = _extractCell(row, columnMap, ['yakın telefonu', 'yakın tel', 'yakin telefonu', 'relative phone']);

      final scheduleStr = _extractCell(row, columnMap, ['çalışma düzeni', 'calisma duzeni', 'düzen', 'schedule']);
      final startDateRaw = _extractRawCell(row, columnMap, ['göreve başlama', 'başlama tarihi', 'goreve baslama', 'start date']);
      final officeStartDateRaw = _extractRawCell(row, columnMap, ['büroya başlama', 'büroya başlama tarihi', 'buroya baslama', 'office start date']);
      final endDateRaw = _extractRawCell(row, columnMap, ['görevden ayrılma', 'ayrılma tarihi', 'gorevden ayrilma', 'end date']);
      final statusStr = _extractCell(row, columnMap, ['durum', 'status']);

      // Zorunlu alan doğrulamaları
      if (registryNumber.isEmpty) {
        rowErrors.add('Sicil numarası boş olamaz.');
      } else if (seenRegistryNumbersInFile.contains(registryNumber)) {
        rowErrors.add('Sicil numarası ($registryNumber) dosya içinde mükerrer.');
      } else {
        seenRegistryNumbersInFile.add(registryNumber);
      }

      if (fullName.isEmpty) {
        rowErrors.add('Ad Soyad alanı boş olamaz.');
      }

      final startDate = _parseDate(startDateRaw);
      if (startDate == null) {
        rowErrors.add('Geçerli bir göreve başlama tarihi girilmelidir.');
      }

      final officeStartDate = _parseDate(officeStartDateRaw);
      final endDate = _parseDate(endDateRaw);

      final status = _parseStatus(statusStr);
      final workSchedule = _parseWorkSchedule(scheduleStr, startDate ?? DateTime.now());

      final isDuplicate = existingRegistryNumbers.contains(registryNumber);

      Personnel? person;
      if (rowErrors.isEmpty && startDate != null) {
        person = Personnel(
          id: null,
          registryNumber: registryNumber,
          fullName: fullName,
          rank: rank.isNotEmpty ? rank : 'Polis Memuru',
          title: title.isNotEmpty ? title : 'Memur',
          branch: branch.isNotEmpty ? branch : '-',
          department: department.isNotEmpty ? department : '-',
          phone: phone,
          email: email,
          address: address,
          bloodType: bloodType.isNotEmpty && bloodType != '-' ? bloodType : null,
          relativeName: relativeName.isNotEmpty && relativeName != '-' ? relativeName : null,
          relativePhone: relativePhone.isNotEmpty && relativePhone != '-' ? relativePhone : null,
          startDate: startDate,
          officeStartDate: officeStartDate,
          endDate: endDate,
          status: status,
          workSchedule: workSchedule,
        );
      }

      allRows.add(
        PersonnelImportRow(
          rowNumber: rowNum,
          personnel: person,
          errors: rowErrors,
          isDuplicate: isDuplicate,
        ),
      );
    }

    return PersonnelImportAnalysis(
      totalRows: allRows.length,
      allRows: allRows,
    );
  }

  Map<String, int> _buildColumnMap(List<Data?> headerRow) {
    final map = <String, int>{};
    for (var i = 0; i < headerRow.length; i++) {
      final cellStr = _cellToString(headerRow[i]).toLowerCase().trim();
      if (cellStr.isNotEmpty) {
        map[cellStr] = i;
      }
    }
    return map;
  }

  bool _isRowEmpty(List<Data?> row) {
    for (final cell in row) {
      if (_cellToString(cell).trim().isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  String _extractCell(
    List<Data?> row,
    Map<String, int> columnMap,
    List<String> possibleNames,
  ) {
    final cell = _extractRawCell(row, columnMap, possibleNames);
    return _cellToString(cell).trim();
  }

  Data? _extractRawCell(
    List<Data?> row,
    Map<String, int> columnMap,
    List<String> possibleNames,
  ) {
    for (final name in possibleNames) {
      final normalized = name.toLowerCase().trim();
      if (columnMap.containsKey(normalized)) {
        final index = columnMap[normalized]!;
        if (index < row.length) {
          return row[index];
        }
      }
    }
    return null;
  }

  String _cellToString(Data? cell) {
    if (cell == null || cell.value == null) return '';
    final val = cell.value;
    if (val is TextCellValue) {
      final text = val.value.text;
      return (text ?? val.value.toString()).trim();
    }
    if (val is IntCellValue) return val.value.toString();

    if (val is DoubleCellValue) {
      final d = val.value;
      return d == d.roundToDouble() ? d.toInt().toString() : d.toString();
    }
    if (val is DateCellValue) {
      return '${val.day.toString().padLeft(2, '0')}.${val.month.toString().padLeft(2, '0')}.${val.year}';
    }
    if (val is DateTimeCellValue) {
      return '${val.day.toString().padLeft(2, '0')}.${val.month.toString().padLeft(2, '0')}.${val.year}';
    }
    return val.toString().trim();
  }

  DateTime? _parseDate(Data? cell) {
    if (cell == null || cell.value == null) return null;
    final val = cell.value;

    if (val is DateCellValue) {
      return DateTime(val.year, val.month, val.day);
    }
    if (val is DateTimeCellValue) {
      return DateTime(val.year, val.month, val.day);
    }

    if (val is IntCellValue) {
      // Excel seri gün numarası desteği (örn. 44197 -> 2021-01-01)
      if (val.value > 1000 && val.value < 70000) {
        return DateTime(1899, 12, 30).add(Duration(days: val.value));
      }
    }
    if (val is DoubleCellValue) {
      final intDays = val.value.toInt();
      if (intDays > 1000 && intDays < 70000) {
        return DateTime(1899, 12, 30).add(Duration(days: intDays));
      }
    }

    final str = _cellToString(cell).trim();
    if (str.isEmpty || str == '-') return null;

    // DD.MM.YYYY veya DD/MM/YYYY veya YYYY-MM-DD
    final dotParts = str.split('.');
    if (dotParts.length == 3) {
      final day = int.tryParse(dotParts[0]);
      final month = int.tryParse(dotParts[1]);
      final year = int.tryParse(dotParts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final slashParts = str.split('/');
    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]);
      final month = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final dashParts = str.split('-');
    if (dashParts.length == 3) {
      if (dashParts[0].length == 4) {
        final year = int.tryParse(dashParts[0]);
        final month = int.tryParse(dashParts[1]);
        final day = int.tryParse(dashParts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      } else {
        final day = int.tryParse(dashParts[0]);
        final month = int.tryParse(dashParts[1]);
        final year = int.tryParse(dashParts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    }

    return DateTime.tryParse(str);
  }

  PersonnelStatus _parseStatus(String raw) {
    final lower = raw.toLowerCase().trim();
    if (lower.contains('istirahat')) return PersonnelStatus.resting;
    if (lower.contains('izin')) return PersonnelStatus.leave;
    if (lower.contains('rapor')) return PersonnelStatus.sickReport;
    return PersonnelStatus.duty;
  }

  WorkSchedule? _parseWorkSchedule(String raw, DateTime startDate) {
    if (raw.isEmpty || raw == '-') return null;
    final clean = raw.trim();

    final parts = clean.split('+');
    if (parts.length == 2) {
      final duty = int.tryParse(parts[0].trim());
      final rest = int.tryParse(parts[1].trim());
      if (duty != null && rest != null && duty > 0 && rest > 0) {
        WorkScheduleType type;
        if (duty == 2 && rest == 1) {
          type = WorkScheduleType.twoPlusOne;
        } else if (duty == 1 && rest == 1) {
          type = WorkScheduleType.onePlusOne;
        } else if (duty == 6 && rest == 1) {
          type = WorkScheduleType.sixPlusOne;
        } else if (duty == 5 && rest == 2) {
          type = WorkScheduleType.fivePlusTwo;
        } else {
          type = WorkScheduleType.custom;
        }

        return WorkSchedule(
          type: type,
          dutyDays: duty,
          restDays: rest,
          startDate: startDate,
        );
      }
    }
    return null;
  }
}
