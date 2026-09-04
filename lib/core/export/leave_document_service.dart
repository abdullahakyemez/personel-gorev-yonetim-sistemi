import 'package:docx_creator/docx_creator.dart';

import '../../features/leave/domain/extensions/leave_type_extension.dart';
import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import 'export_file_service.dart';

class LeaveDocumentService {
  Future<String?> exportLeaveDocument({
    required Leave leave,
    required Personnel person,
  }) async {
    final startDate = _date(leave.startDate);
    final addedDate = _date(DateTime.now());
    final dayCount = leave.dayCount;

    final document = docx()
        .section(
          orientation: DocxPageOrientation.portrait,
          pageSize: DocxPageSize.a4,
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText(
                'ASAYİŞ ŞUBE MÜDÜRLÜĞÜNE',
                fontFamily: 'Arial',
                fontSize: 12,
                fontWeight: DocxFontWeight.bold,
              ),
            ],
          ),
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText(
                '(İdari Büro Amirliği)',
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .p('')
        .add(
          DocxParagraph(
            children: [
              DocxText(
                '${person.registryNumber} sicil sayılı ${person.rank} olarak ${person.branch} bürosunda görev yapmaktayım. '
                '$startDate geçerli $dayCount (${_numberToWords(dayCount)}) gün ${leave.type.label} kullanmak istiyorum.',
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .p('')
        .add(
          DocxParagraph(
            children: [
              DocxText(
                'Gereğini Arz Ederim. $addedDate',
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .p('')
        .add(
          DocxParagraph(
            align: DocxAlign.right,
            children: [
              DocxText(person.fullName, fontFamily: 'Arial', fontSize: 12),
              DocxText('\n${person.rank}', fontFamily: 'Arial', fontSize: 12),
            ],
          ),
        )
        .p('')
        .add(
          DocxParagraph(
            children: [
              DocxText(
                'İznini Geçireceği Adres:',
                fontFamily: 'Arial',
                fontSize: 12,
                fontWeight: DocxFontWeight.bold,
                decorations: const [DocxTextDecoration.underline],
              ),
            ],
          ),
        )
        .add(
          DocxParagraph(
            children: [
              DocxText(
                leave.address.isNotEmpty
                    ? leave.address
                    : (person.address.isEmpty ? '-' : person.address),
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .add(
          DocxParagraph(
            children: [
              DocxText(
                'Tel: ${person.phone.isEmpty ? '-' : person.phone}',
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .p('')
        .p('')
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText(
                'GÖRÜLDÜ',
                fontFamily: 'Arial',
                fontSize: 12,
                fontWeight: DocxFontWeight.bold,
              ),
            ],
          ),
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [DocxText(addedDate, fontFamily: 'Arial', fontSize: 12)],
          ),
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText('Abdullah HAKYEMEZ', fontFamily: 'Arial', fontSize: 12),
            ],
          ),
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText('Başkomiser', fontFamily: 'Arial', fontSize: 12),
            ],
          ),
        )
        .add(
          DocxParagraph(
            align: DocxAlign.center,
            children: [
              DocxText(
                '${person.branch} Büro Amiri',
                fontFamily: 'Arial',
                fontSize: 12,
              ),
            ],
          ),
        )
        .build();

    final bytes = await DocxExporter().exportToBytes(document);
    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName:
          '${_safeFile(person.fullName)}_Izin_Belgesi_$startDate.docx',
      extension: 'docx',
      mimeType:
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    );
  }

  static String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  static String _safeFile(String value) =>
      value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();

  static String _numberToWords(int number) {
    const ones = <String>[
      'sıfır',
      'bir',
      'iki',
      'üç',
      'dört',
      'beş',
      'altı',
      'yedi',
      'sekiz',
      'dokuz',
    ];
    const tens = <String>[
      '',
      '',
      'yirmi',
      'otuz',
      'kırk',
      'elli',
      'altmış',
      'yetmiş',
      'seksen',
      'doksan',
    ];

    if (number < 10) return ones[number];
    if (number < 100) {
      final ten = number ~/ 10;
      final one = number % 10;
      return '${tens[ten]}${one == 0 ? '' : ' ${ones[one]}'}';
    }
    if (number < 1000) {
      final hundred = number ~/ 100;
      final remainder = number % 100;
      final prefix = hundred == 1 ? 'yüz' : '${ones[hundred]} yüz';
      return '$prefix${remainder == 0 ? '' : ' ${_numberToWords(remainder)}'}';
    }
    return number.toString();
  }
}
