import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';

import '../../features/personnel/domain/models/personnel.dart';
import '../../features/task/domain/extensions/task_category_extension.dart';
import '../../features/task/domain/extensions/task_status_extension.dart';
import '../../features/task/domain/models/task.dart';
import 'export_file_service.dart';

class TaskExcelExportService {
  static const _mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  Uint8List? generateExcelBytes({
    required List<Task> tasks,
    required List<Personnel> personnel,
  }) {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Görevler');
    final sheet = excel['Görevler'];

    final headers = [
      'Durum',
      'Görev Başlığı',
      'Açıklama',
      'Kategori',
      'Başlangıç Tarihi',
      'Bitiş Tarihi',
      'Personel Sayısı',
      'Görevlendirilen Personel',
    ];

    sheet.appendRow(headers.map(TextCellValue.new).toList());

    final personnelMap = {
      for (final p in personnel)
        if (p.id != null) p.id!: p,
    };

    for (final task in tasks) {
      final assignedNames = task.personnelIds
          .map((id) => personnelMap[id]?.fullName ?? 'Sicil: $id')
          .join(', ');

      sheet.appendRow([
        TextCellValue(task.status.label),
        TextCellValue(task.title),
        TextCellValue(task.description),
        TextCellValue(task.category?.label ?? 'Genel'),
        TextCellValue(_date(task.startDate)),
        TextCellValue(_date(task.endDate)),
        IntCellValue(task.personnelIds.length),
        TextCellValue(assignedNames),
      ]);
    }

    return Uint8List.fromList(excel.encode() ?? []);
  }

  Future<void> exportAndSave({
    required List<Task> tasks,
    required List<Personnel> personnel,
  }) async {
    final bytes = generateExcelBytes(tasks: tasks, personnel: personnel);
    if (bytes == null || bytes.isEmpty) return;

    final now = DateTime.now();
    final fileName =
        'gorevler_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.xlsx';

    await ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName: fileName,
      extension: 'xlsx',
      mimeType: _mimeType,
    );
  }

  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
