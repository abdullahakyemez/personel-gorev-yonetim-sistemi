import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/leave/domain/extensions/leave_type_extension.dart';
import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import '../../features/task/domain/extensions/task_status_extension.dart';
import '../../features/task/domain/extensions/task_category_extension.dart';
import '../../features/task/domain/models/task.dart';
import '../../features/task/domain/models/task_category.dart';
import 'export_file_service.dart';
import 'report_export_data.dart';

class ReportPdfExportService {
  /// Generates raw PDF bytes for a leave and sick report export.
  static Future<Uint8List> generateLeavePdfBytes({
    required DateTime startDate,
    required DateTime endDate,
    required List<Personnel> personnel,
    required List<Leave> leaves,
    pw.Font? font,
    pw.Font? boldFont,
  }) async {
    final effectiveFont = font ?? await _loadAppFont();
    final effectiveBoldFont = boldFont ?? await _loadAppBoldFont();
    final document = pw.Document(
      title: 'İzin ve Rapor Raporu',
      author: 'Personel ve Görev Yönetim Sistemi',
    );
    final data = ReportExportData(
      startDate: startDate,
      endDate: endDate,
      personnel: personnel,
      leaves: leaves,
      tasks: const [],
    );
    final personnelById = {
      for (final person in personnel)
        if (person.id != null) person.id!: person,
    };

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: _theme(effectiveFont, effectiveBoldFont),
        header: (_) => pw.Text(
          'İZİN VE RAPOR RAPORU',
          style: pw.TextStyle(
            font: effectiveFont,
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Sayfa ${context.pageNumber}',
            style: pw.TextStyle(font: effectiveFont, fontSize: 8),
          ),
        ),
        build: (_) {
          final widgets = <pw.Widget>[
            pw.SizedBox(height: 8),
            pw.Text('Rapor Tarih Aralığı: ${_period(startDate, endDate)}'),
            pw.SizedBox(height: 14),
          ];

          if (data.periods.isEmpty) {
            widgets.add(
              pw.Text(
                'Seçilen tarih aralığında çalışma dönemi bulunmuyor.',
                style: pw.TextStyle(
                  font: effectiveFont,
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            );
          } else {
            for (final period in data.periods) {
              final rangeStart = _maxDate(period.start, startDate);
              final rangeEnd = _minDate(period.end, endDate);
              final periodLeaves = leaves.where((leave) {
                return _overlaps(
                  leave.startDate,
                  leave.endDate,
                  rangeStart,
                  rangeEnd,
                );
              }).toList()
                ..sort((a, b) => a.startDate.compareTo(b.startDate));

              widgets.add(
                pw.Text(
                  '${period.label} Çalışma Dönemi',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              );
              widgets.add(pw.SizedBox(height: 8));

              if (periodLeaves.isEmpty) {
                widgets.add(
                  pw.Text(
                    'Bu çalışma dönemine ait izin veya rapor kaydı bulunmuyor.',
                    style: pw.TextStyle(
                      font: effectiveFont,
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                );
              } else {
                widgets.add(
                  pw.TableHelper.fromTextArray(
                    headers: const [
                      'İzin/Rapor',
                      'Sicil',
                      'Personel',
                      'Rütbe',
                      'Büro',
                      'Başlangıç',
                      'Bitiş',
                      'Gün',
                    ],
                    data: periodLeaves
                        .map(
                          (leave) {
                            final person = personnelById[leave.personnelId];
                            return [
                              leave.type.label,
                              person?.registryNumber ?? leave.personnelId.toString(),
                              person?.fullName ?? '-',
                              person?.rank ?? '-',
                              person?.branch ?? '-',
                              _date(leave.startDate),
                              _date(leave.endDate),
                              '${data.clippedDays(leave.startDate, leave.endDate, rangeStart, rangeEnd)}',
                            ];
                          },
                        )
                        .toList(),
                    headerStyle: pw.TextStyle(
                      font: effectiveFont,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellStyle: pw.TextStyle(font: effectiveFont, fontSize: 7),
                    cellPadding: const pw.EdgeInsets.all(4),
                    border: pw.TableBorder.all(width: 0.4),
                  ),
                );
              }
              widgets.add(pw.SizedBox(height: 18));
            }
          }

          return widgets;
        },
      ),
    );

    return document.save();
  }

  static Future<String?> exportLeaveReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<Personnel> personnel,
    required List<Leave> leaves,
    pw.Font? font,
  }) async {
    final bytes = await generateLeavePdfBytes(
      startDate: startDate,
      endDate: endDate,
      personnel: personnel,
      leaves: leaves,
      font: font,
    );

    return _savePdf(
      bytes,
      'Izin_Raporu_${_fileDate(startDate)}_${_fileDate(endDate)}.pdf',
    );
  }

  /// Generates raw PDF bytes for an individual personnel report.
  static Future<Uint8List> generatePersonnelPdfBytes({
    required DateTime startDate,
    required DateTime endDate,
    required Personnel person,
    required List<Task> tasks,
    required List<Leave> leaves,
    pw.Font? font,
    pw.Font? boldFont,
  }) async {
    final effectiveFont = font ?? await _loadAppFont();
    final effectiveBoldFont = boldFont ?? await _loadAppBoldFont();
    final document = pw.Document(
      title: '${person.fullName} Personel Raporu',
      author: 'Personel ve Görev Yönetim Sistemi',
    );
    final data = ReportExportData(
      startDate: startDate,
      endDate: endDate,
      personnel: [person],
      leaves: leaves,
      tasks: tasks,
    );

    final personTasks = tasks.where((task) {
      return person.id != null &&
          task.personnelIds.contains(person.id) &&
          _overlaps(task.startDate, task.endDate, startDate, endDate);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final personLeaves = leaves.where((leave) {
      return leave.personnelId == person.id &&
          _overlaps(leave.startDate, leave.endDate, startDate, endDate);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: _theme(effectiveFont, effectiveBoldFont),
        header: (_) => pw.Text(
          'PERSONEL RAPORU',
          style: pw.TextStyle(
            font: effectiveFont,
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Sayfa ${context.pageNumber}',
            style: pw.TextStyle(font: effectiveFont, fontSize: 8),
          ),
        ),
        build: (_) {
          final widgets = <pw.Widget>[
            pw.Text('Rapor Tarih Aralığı: ${_period(startDate, endDate)}'),
            pw.SizedBox(height: 12),
            pw.Text(
              'Personel Bilgileri',
              style: pw.TextStyle(
                font: effectiveFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: const ['Alan', 'Bilgi'],
              data: [
                ['Sicil', person.registryNumber],
                ['Ad Soyad', person.fullName],
                ['Rütbe', person.rank],
                ['Ünvan', person.title],
                ['Şube', person.department],
                ['Büro', person.branch],
                ['Telefon', person.phone],
                ['E-posta', person.email],
                ['Adres', person.address],
                ['Kan Grubu', person.bloodType ?? '-'],
                ['Yakın Adı', person.relativeName ?? '-'],
                ['Yakın Telefonu', person.relativePhone ?? '-'],
                ['Çalışma Düzeni', person.workSchedule?.label ?? '-'],
              ],
              headerStyle: pw.TextStyle(
                font: effectiveFont,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(font: effectiveFont, fontSize: 7),
              border: pw.TableBorder.all(width: 0.4),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Görev İstatistikleri',
              style: pw.TextStyle(
                font: effectiveFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: const ['Görev Türü', 'Adet'],
              data: [
                ['Toplam Görev', '${personTasks.length}'],
                ...TaskCategory.values.map(
                  (category) => [
                    category.label,
                    '${personTasks.where((task) => task.category == category).length}',
                  ],
                ),
              ],
              headerStyle: pw.TextStyle(
                font: effectiveFont,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(font: effectiveFont, fontSize: 7),
              border: pw.TableBorder.all(width: 0.4),
            ),
            pw.SizedBox(height: 16),
          ];

          if (data.periods.isEmpty) {
            widgets.add(
              pw.Text(
                'Seçilen tarih aralığında çalışma dönemi bulunmuyor.',
                style: pw.TextStyle(
                  font: effectiveFont,
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            );
          } else {
            for (final period in data.periods) {
              final rangeStart = _maxDate(period.start, startDate);
              final rangeEnd = _minDate(period.end, endDate);
              final periodTasks = personTasks.where((task) {
                return _overlaps(
                  task.startDate,
                  task.endDate,
                  rangeStart,
                  rangeEnd,
                );
              }).toList();
              final periodLeaves = personLeaves.where((leave) {
                return _overlaps(
                  leave.startDate,
                  leave.endDate,
                  rangeStart,
                  rangeEnd,
                );
              }).toList();

              widgets.add(
                pw.Text(
                  '${period.label} Çalışma Dönemi',
                  style: pw.TextStyle(
                    font: effectiveFont,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              );
              widgets.add(pw.SizedBox(height: 8));
              widgets.add(_sectionTitle('Görevler', effectiveFont));
              if (periodTasks.isEmpty) {
                widgets.add(
                  pw.Text(
                    'Bu dönemde görev kaydı bulunmuyor.',
                    style: pw.TextStyle(
                      font: effectiveFont,
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                );
              } else {
                widgets.add(_taskTable(periodTasks, effectiveFont));
              }
              widgets.add(pw.SizedBox(height: 10));

              final nonReportLeaves = periodLeaves.where((leave) => leave.type != LeaveType.report);
              widgets.add(_sectionTitle('İzinler', effectiveFont));
              if (nonReportLeaves.isEmpty) {
                widgets.add(
                  pw.Text(
                    'Bu dönemde izin kaydı bulunmuyor.',
                    style: pw.TextStyle(
                      font: effectiveFont,
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                );
              } else {
                widgets.add(
                  _leaveTable(
                    nonReportLeaves,
                    data,
                    rangeStart,
                    rangeEnd,
                    effectiveFont,
                  ),
                );
              }
              widgets.add(pw.SizedBox(height: 10));

              final reportLeaves = periodLeaves.where((leave) => leave.type == LeaveType.report);
              widgets.add(_sectionTitle('Raporlar', effectiveFont));
              if (reportLeaves.isEmpty) {
                widgets.add(
                  pw.Text(
                    'Bu dönemde sağlık raporu kaydı bulunmuyor.',
                    style: pw.TextStyle(
                      font: effectiveFont,
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                );
              } else {
                widgets.add(
                  _reportTable(
                    reportLeaves,
                    data,
                    rangeStart,
                    rangeEnd,
                    effectiveFont,
                  ),
                );
              }
              widgets.add(pw.SizedBox(height: 18));
            }
          }

          return widgets;
        },
      ),
    );

    return document.save();
  }

  static Future<String?> exportPersonnelReport({
    required DateTime startDate,
    required DateTime endDate,
    required Personnel person,
    required List<Task> tasks,
    required List<Leave> leaves,
    pw.Font? font,
  }) async {
    final bytes = await generatePersonnelPdfBytes(
      startDate: startDate,
      endDate: endDate,
      person: person,
      tasks: tasks,
      leaves: leaves,
      font: font,
    );

    return _savePdf(
      bytes,
      '${_safeFile(person.fullName)}_Personel_Raporu_${_fileDate(startDate)}_${_fileDate(endDate)}.pdf',
    );
  }

  static pw.Widget _sectionTitle(String title, pw.Font? font) {
    return pw.Text(
      title,
      style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
    );
  }

  static pw.Widget _taskTable(List<Task> tasks, pw.Font? font) {
    return pw.TableHelper.fromTextArray(
      headers: const ['Tür', 'Başlangıç', 'Bitiş', 'Durum'],
      data: tasks
          .map(
            (task) => [
              task.category?.label ?? task.title,
              _date(task.startDate),
              _date(task.endDate),
              task.status.label,
            ],
          )
          .toList(),
      headerStyle: pw.TextStyle(font: font, fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: pw.TextStyle(font: font, fontSize: 7),
      border: pw.TableBorder.all(width: 0.4),
    );
  }

  static pw.Widget _leaveTable(
    Iterable<Leave> leaves,
    ReportExportData data,
    DateTime rangeStart,
    DateTime rangeEnd,
    pw.Font? font,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: const ['Tür', 'Başlangıç', 'Bitiş', 'Gün'],
      data: leaves
          .map(
            (leave) => [
              leave.type.label,
              _date(leave.startDate),
              _date(leave.endDate),
              '${data.clippedDays(leave.startDate, leave.endDate, rangeStart, rangeEnd)}',
            ],
          )
          .toList(),
      headerStyle: pw.TextStyle(font: font, fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: pw.TextStyle(font: font, fontSize: 7),
      border: pw.TableBorder.all(width: 0.4),
    );
  }

  static pw.Widget _reportTable(
    Iterable<Leave> leaves,
    ReportExportData data,
    DateTime rangeStart,
    DateTime rangeEnd,
    pw.Font? font,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: const ['Başlangıç', 'Bitiş', 'Gün', 'Açıklama'],
      data: leaves
          .map(
            (leave) => [
              _date(leave.startDate),
              _date(leave.endDate),
              '${data.clippedDays(leave.startDate, leave.endDate, rangeStart, rangeEnd)}',
              leave.description,
            ],
          )
          .toList(),
      headerStyle: pw.TextStyle(font: font, fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: pw.TextStyle(font: font, fontSize: 7),
      border: pw.TableBorder.all(width: 0.4),
    );
  }

  static Future<String?> _savePdf(
    Uint8List bytes,
    String suggestedName,
  ) async {
    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName: suggestedName,
      extension: 'pdf',
      mimeType: 'application/pdf',
    );
  }

  static Future<pw.Font?> _loadAppFont() async {
    // 1. Öncelik: Asset içindeki açık kaynaklı Roboto fontu (Cross-platform)
    try {
      final fontData = await rootBundle.load('assets/fonts/roboto-regular.ttf');
      return pw.Font.ttf(fontData);
    } catch (_) {}

    // 2. Yedek: Yerel dosya sisteminden asset kontrolü (Test ortamları için)
    final localAsset = File('assets/fonts/roboto-regular.ttf');
    if (await localAsset.exists()) {
      try {
        final bytes = await localAsset.readAsBytes();
        return pw.Font.ttf(Uint8List.fromList(bytes).buffer.asByteData());
      } catch (_) {}
    }

    // 3. Yedek: Windows sistem fontları (Arial, Segoe UI, Calibri)
    return await _loadWindowsFont();
  }

  static Future<pw.Font?> _loadAppBoldFont() async {
    // 1. Öncelik: Asset içindeki açık kaynaklı Roboto Bold fontu
    try {
      final fontData = await rootBundle.load('assets/fonts/roboto-bold.ttf');
      return pw.Font.ttf(fontData);
    } catch (_) {}

    // 2. Yedek: Yerel dosya sisteminden asset kontrolü (Test ortamları için)
    final localAsset = File('assets/fonts/roboto-bold.ttf');
    if (await localAsset.exists()) {
      try {
        final bytes = await localAsset.readAsBytes();
        return pw.Font.ttf(Uint8List.fromList(bytes).buffer.asByteData());
      } catch (_) {}
    }

    // 3. Yedek: Windows sistem fontları (Arial Bold, Segoe UI Bold)
    if (Platform.isWindows) {
      for (final path in <String>[
        r'C:\Windows\Fonts\arialbd.ttf',
        r'C:\Windows\Fonts\segoeuib.ttf',
        r'C:\Windows\Fonts\calibrib.ttf',
      ]) {
        final file = File(path);
        if (await file.exists()) {
          try {
            final bytes = await file.readAsBytes();
            return pw.Font.ttf(Uint8List.fromList(bytes).buffer.asByteData());
          } catch (_) {
            continue;
          }
        }
      }
    }
    return null;
  }

  static Future<pw.Font?> _loadWindowsFont() async {
    if (!Platform.isWindows) return null;
    for (final path in <String>[
      r'C:\Windows\Fonts\arial.ttf',
      r'C:\Windows\Fonts\segoeui.ttf',
      r'C:\Windows\Fonts\calibri.ttf',
    ]) {
      final file = File(path);
      if (await file.exists()) {
        try {
          final bytes = await file.readAsBytes();
          return pw.Font.ttf(Uint8List.fromList(bytes).buffer.asByteData());
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  static pw.ThemeData _theme(pw.Font? font, [pw.Font? boldFont]) {
    if (font == null) return pw.ThemeData.base();
    return pw.ThemeData.withFont(
      base: font,
      bold: boldFont ?? font,
      italic: font,
      boldItalic: boldFont ?? font,
    );
  }

  static bool _overlaps(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
    final startA = DateTime(aStart.year, aStart.month, aStart.day);
    final endA = DateTime(aEnd.year, aEnd.month, aEnd.day);
    final startB = DateTime(bStart.year, bStart.month, bStart.day);
    final endB = DateTime(bEnd.year, bEnd.month, bEnd.day);
    return !endA.isBefore(startB) && !startA.isAfter(endB);
  }

  static DateTime _maxDate(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
  static DateTime _minDate(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

  static String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  static String _period(DateTime start, DateTime end) => '${_date(start)} - ${_date(end)}';

  static String _fileDate(DateTime value) =>
      '${value.year}${value.month.toString().padLeft(2, '0')}${value.day.toString().padLeft(2, '0')}';

  static String _safeFile(String value) => value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
}
