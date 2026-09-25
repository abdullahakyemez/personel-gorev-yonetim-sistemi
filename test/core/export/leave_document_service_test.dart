import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_document_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final samplePerson = Personnel(
    id: 1,
    registryNumber: '318627',
    fullName: 'Ulvi GÖNÜLTAŞ',
    rank: 'Polis Memuru',
    title: 'Memur',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Hırsızlık-Oto Hırsızlığı Büro Amirliği',
    phone: '0 506 845 06 96',
    email: 'ulvi@example.com',
    address: 'Gördes / MANİSA',
    startDate: DateTime(2020, 1, 1),
    status: PersonnelStatus.duty,
  );

  final sampleLeave = Leave(
    id: 'leave-1',
    personnelId: 1,
    type: LeaveType.annual,
    startDate: DateTime(2026, 8, 24),
    endDate: DateTime(2026, 9, 11), // 19 days
    description: '15+4 Yol izni dahil',
    address: 'Gördes / MANİSA',
  );

  group('LeaveDocumentService Tests', () {
    test('generateDocumentBytes creates a valid docx archive with document.xml', () async {
      final service = LeaveDocumentService();
      final bytes = await service.generateDocumentBytes(
        leave: sampleLeave,
        person: samplePerson,
      );

      expect(bytes, isNotEmpty);

      final archive = ZipDecoder().decodeBytes(bytes);
      expect(archive.findFile('word/document.xml'), isNotNull);
      expect(archive.findFile('[Content_Types].xml'), isNotNull);
      expect(archive.findFile('word/styles.xml'), isNotNull);
    });

    test('document.xml contains identical styling, fonts and dynamic personnel data', () async {
      final service = LeaveDocumentService();
      final bytes = await service.generateDocumentBytes(
        leave: sampleLeave,
        person: samplePerson,
        amirName: 'Abdullah HAKYEMEZ',
        amirTitle: 'Hırsızlık ve Yankesicilik Büro Amiri',
        amirRank: 'Başkomiser',
      );

      final archive = ZipDecoder().decodeBytes(bytes);
      final documentFile = archive.findFile('word/document.xml')!;
      final xmlString = utf8.decode(documentFile.content as List<int>);

      // Font ve sayfa yapısı kontrolleri
      expect(xmlString, contains('w:ascii="Times New Roman"'));
      expect(xmlString, contains('w:sz w:val="24"')); // 12pt
      expect(xmlString, contains('w:ind w:firstLine="708"')); // 1.25cm ilk satır girintisi
      expect(xmlString, contains('w:w="11906" w:h="16838"')); // A4 sayfa ebatları
      expect(xmlString, contains('w:top="993"')); // Üst kenar boşluğu
      expect(xmlString, contains('w:bottom="1417"')); // Alt kenar boşluğu

      // Dinamik alan kontrolleri
      expect(xmlString, contains('318627'));
      expect(xmlString, contains('Polis Memuru'));
      expect(xmlString, contains('Hırsızlık-Oto Hırsızlığı Büro Amirliği'));
      expect(xmlString, contains('24.08.2026'));
      expect(xmlString, contains('15+4 (ondokuz)'));
      expect(xmlString, contains('senelik izne'));
      expect(xmlString, contains('Ulvi GÖNÜLTAŞ'));
      expect(xmlString, contains('Gördes / MANİSA'));
      expect(xmlString, contains('0 506 845 06 96'));
      expect(xmlString, contains('GÖRÜLDÜ'));
      expect(xmlString, contains('Abdullah HAKYEMEZ'));
      expect(xmlString, contains('Hırsızlık ve Yankesicilik Büro Amiri'));
      expect(xmlString, contains('Başkomiser'));
    });

    test('highlightDynamicFieldsInRed adds C9211E color to dynamic fields', () async {
      final service = LeaveDocumentService();
      final bytes = await service.generateDocumentBytes(
        leave: sampleLeave,
        person: samplePerson,
        highlightDynamicFieldsInRed: true,
      );

      final archive = ZipDecoder().decodeBytes(bytes);
      final documentFile = archive.findFile('word/document.xml')!;
      final xmlString = utf8.decode(documentFile.content as List<int>);

      expect(xmlString, contains('<w:color w:val="C9211E"/>'));
    });

    test('leave types map to correct Turkish dative phrases', () async {
      final service = LeaveDocumentService();

      final excuseLeave = sampleLeave.copyWith(type: LeaveType.excuse, description: '');
      final excuseBytes = await service.generateDocumentBytes(
        leave: excuseLeave,
        person: samplePerson,
      );
      final excuseXml = utf8.decode(ZipDecoder().decodeBytes(excuseBytes).findFile('word/document.xml')!.content as List<int>);
      expect(excuseXml, contains('mazeret iznine'));

      final reportLeave = sampleLeave.copyWith(type: LeaveType.report, description: '');
      final reportBytes = await service.generateDocumentBytes(
        leave: reportLeave,
        person: samplePerson,
      );
      final reportXml = utf8.decode(ZipDecoder().decodeBytes(reportBytes).findFile('word/document.xml')!.content as List<int>);
      expect(reportXml, contains('sıhhi izne'));
    });

    test('isActing true injects Büro Amir V. into approval title block', () async {
      final service = LeaveDocumentService();

      final actingBytes = await service.generateDocumentBytes(
        leave: sampleLeave,
        person: samplePerson,
        amirName: 'Mehmet DEMİR',
        amirRank: 'Komiser',
        isActing: true,
      );

      final actingXml = utf8.decode(
        ZipDecoder().decodeBytes(actingBytes).findFile('word/document.xml')!.content as List<int>,
      );

      expect(actingXml, contains('Mehmet DEMİR'));
      expect(actingXml, contains('Komiser'));
      expect(actingXml, contains('Hırsızlık-Oto Hırsızlığı Büro Amir V.'));
    });
  });
}
