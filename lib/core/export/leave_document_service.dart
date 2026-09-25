import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;

import '../../features/leave/domain/models/leave.dart';
import '../../features/personnel/domain/models/personnel.dart';
import 'export_file_service.dart';

class LeaveDocumentService {
  /// Şablon dosyasının bayt verilerini önce varlıklardan (assets),
  /// bulunamazsa dosya sisteminden yükler.
  Future<List<int>> _loadTemplateBytes() async {
    // 1. Flutter asset bundle üzerinden yüklemeyi dene
    try {
      final byteData = await rootBundle.load(
        'assets/templates/personel_izin_dilekcesi.docx',
      );
      return byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
    } catch (_) {}

    // 2. Test ve komut satırı ortamları için yerel dosya sistemini dene
    final candidatePaths = [
      'assets/templates/personel_izin_dilekcesi.docx',
      'personel_izin_dilekcesi.docx',
      p.join(Directory.current.path, 'assets', 'templates', 'personel_izin_dilekcesi.docx'),
      p.join(Directory.current.path, 'personel_izin_dilekcesi.docx'),
    ];

    for (final path in candidatePaths) {
      final file = File(path);
      if (file.existsSync()) {
        return file.readAsBytesSync();
      }
    }

    throw StateError(
      'İzin dilekçesi şablon dosyası (personel_izin_dilekcesi.docx) bulunamadı.',
    );
  }

  /// Şablon dosyasını okuyup dinamik alanları doldurarak DOCX bayt dizisi üretir.
  Future<List<int>> generateDocumentBytes({
    required Leave leave,
    required Personnel person,
    String amirName = 'Abdullah HAKYEMEZ',
    String? amirTitle,
    String amirRank = 'Başkomiser',
    bool isActing = false,
    bool highlightDynamicFieldsInRed = false,
  }) async {
    final templateBytes = await _loadTemplateBytes();
    final archive = ZipDecoder().decodeBytes(templateBytes);

    final String defaultBranchTitle;
    final branchTrimmed = person.branch.trim();
    if (branchTrimmed.endsWith('Büro Amirliği')) {
      final base = branchTrimmed
          .substring(0, branchTrimmed.length - 'Büro Amirliği'.length)
          .trim();
      defaultBranchTitle =
          isActing ? '$base Büro Amir V.' : '$base Büro Amiri';
    } else {
      defaultBranchTitle =
          isActing ? '$branchTrimmed Büro Amir V.' : '$branchTrimmed Büro Amiri';
    }
    final resolvedAmirTitle = amirTitle?.trim().isNotEmpty == true
        ? amirTitle!.trim()
        : defaultBranchTitle;

    final documentXml = _buildDocumentXml(
      leave: leave,
      person: person,
      amirName: amirName,
      amirTitle: resolvedAmirTitle,
      amirRank: amirRank,
      highlightDynamicFieldsInRed: highlightDynamicFieldsInRed,
    );

    final updatedArchive = Archive();
    final documentXmlBytes = utf8.encode(documentXml);

    for (final file in archive.files) {
      if (file.name == 'word/document.xml') {
        updatedArchive.addFile(
          ArchiveFile(
            'word/document.xml',
            documentXmlBytes.length,
            documentXmlBytes,
          ),
        );
      } else {
        updatedArchive.addFile(file);
      }
    }

    final outputBytes = ZipEncoder().encode(updatedArchive);
    return outputBytes;
  }

  /// İzin dilekçesi Word belgesini oluşturup kullanıcı seçimiyle kaydeder.
  Future<String?> exportLeaveDocument({
    required Leave leave,
    required Personnel person,
    String amirName = 'Abdullah HAKYEMEZ',
    String? amirTitle,
    String amirRank = 'Başkomiser',
    bool isActing = false,
    bool highlightDynamicFieldsInRed = false,
  }) async {
    final bytes = await generateDocumentBytes(
      leave: leave,
      person: person,
      amirName: amirName,
      amirTitle: amirTitle,
      amirRank: amirRank,
      isActing: isActing,
      highlightDynamicFieldsInRed: highlightDynamicFieldsInRed,
    );

    final startDate = _dateDots(leave.startDate);
    return ExportFileService.saveBytes(
      bytes: bytes,
      suggestedName:
          '${_safeFile(person.fullName)}_Izin_Dilekcesi_$startDate.docx',
      extension: 'docx',
      mimeType:
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    );
  }

  /// personel_izin_dilekcesi.docx dosyasının orijinal tasarımı,
  /// fontları, kenar boşlukları ve girintileriyle birebir XML içeriğini üretir.
  String _buildDocumentXml({
    required Leave leave,
    required Personnel person,
    required String amirName,
    required String amirTitle,
    required String amirRank,
    required bool highlightDynamicFieldsInRed,
  }) {
    final colorAttr =
        highlightDynamicFieldsInRed ? '<w:color w:val="C9211E"/>' : '';

    final registryNumber = _escapeXml(person.registryNumber);
    final rank = _escapeXml(person.rank);
    final branch = _escapeXml(person.branch);
    final startDate = _dateDots(leave.startDate);
    final daysText = _escapeXml(_formatDays(leave));
    final leaveTypeStr = _escapeXml(_leaveTypePhrase(leave.type));
    final todayDate = _dateSlashes(DateTime.now());
    final fullName = _escapeXml(person.fullName);

    final resolvedAddress = leave.address.trim().isNotEmpty
        ? leave.address.trim()
        : (person.address.trim().isNotEmpty ? person.address.trim() : '-');
    final address = _escapeXml(resolvedAddress);

    final resolvedPhone =
        person.phone.trim().isNotEmpty ? person.phone.trim() : '-';
    final phone = _escapeXml(resolvedPhone);

    final safeAmirName = _escapeXml(amirName);
    final safeAmirTitle = _escapeXml(amirTitle);
    final safeAmirRank = _escapeXml(amirRank);

    return '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" mc:Ignorable="w14 wp14 w15"><w:body><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>ASAYİŞ ŞUBE MÜDÜRLÜĞÜNE</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>(İdari Büro Amirliği)</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:ind w:firstLine="708"/><w:jc w:val="both"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$registryNumber</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve"> sicil sayılı </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$rank</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve"> olarak </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$branch</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve">nde görev yapmaktayım. </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$startDate</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve"> tarihinden geçerli olmak üzere </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$daysText</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve"> gün </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$leaveTypeStr</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve"> ayrılmak istiyorum.</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:tabs><w:tab w:val="clear" w:pos="708"/><w:tab w:val="left" w:pos="709" w:leader="none"/></w:tabs><w:jc w:val="both"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t xml:space="preserve">     </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:tab/><w:t>Gereğini Arz ederim.</w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$todayDate</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:tabs><w:tab w:val="clear" w:pos="708"/><w:tab w:val="left" w:pos="6435" w:leader="none"/></w:tabs><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:tab/></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="both"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/></w:rPr><w:t xml:space="preserve">                                                                                                                                    </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr</w:rPr><w:t>$fullName</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="both"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr</w:rPr><w:t xml:space="preserve">                                                                                                                                        </w:t></w:r><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr</w:rPr><w:t>$rank</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:b/><w:b/><w:sz w:val="24"/><w:szCs w:val="24"/><w:u w:val="single"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:b/><w:sz w:val="24"/><w:szCs w:val="24"/><w:u w:val="single"/></w:rPr><w:t>İznini Geçireceği Adres:</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$address</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$phone</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="Normal"/><w:rPr></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>GÖRÜLDÜ</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$todayDate</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$safeAmirName</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$safeAmirTitle</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr>$colorAttr</w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>$colorAttr<w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr><w:t>$safeAmirRank</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:cs="Times New Roman" w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:r></w:p><w:p><w:pPr><w:pStyle w:val="NoSpacing"/><w:jc w:val="center"/><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:pPr><w:r><w:rPr></w:rPr></w:r></w:p><w:sectPr><w:type w:val="nextPage"/><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:left="1417" w:right="1417" w:gutter="0" w:header="0" w:top="993" w:footer="0" w:bottom="1417"/><w:pgNumType w:fmt="decimal"/><w:formProt w:val="false"/><w:textDirection w:val="lrTb"/><w:docGrid w:type="default" w:linePitch="360" w:charSpace="4096"/></w:sectPr></w:body></w:document>''';
  }

  static String _formatDays(Leave leave) {
    final regex = RegExp(r'(\d+\s*\+\s*\d+)');
    final match = regex.firstMatch(leave.description);
    if (match != null) {
      final formula = match.group(1)!.replaceAll(' ', '');
      final words = _numberToWords(leave.dayCount);
      return '$formula ($words)';
    }
    final words = _numberToWords(leave.dayCount);
    return '${leave.dayCount} ($words)';
  }

  static String _leaveTypePhrase(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'senelik izne';
      case LeaveType.excuse:
        return 'mazeret iznine';
      case LeaveType.report:
        return 'sıhhi izne';
    }
  }

  static String _escapeXml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  static String _dateDots(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  static String _dateSlashes(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  static String _safeFile(String value) =>
      value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();

  static String _numberToWords(int number) {
    if (number <= 0) return 'sıfır';

    const ones = <String>[
      '',
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
      'on',
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
      return '${tens[ten]}${one == 0 ? '' : ones[one]}';
    }
    if (number < 1000) {
      final hundred = number ~/ 100;
      final remainder = number % 100;
      final prefix = hundred == 1 ? 'yüz' : '${ones[hundred]}yüz';
      return '$prefix${remainder == 0 ? '' : _numberToWords(remainder)}';
    }
    return number.toString();
  }
}
