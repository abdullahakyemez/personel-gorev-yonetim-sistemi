import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExportFileService {
  const ExportFileService._();

  /// Dosya adındaki işletim sistemi tarafından yasaklanmış karakterleri temizler.
  static String sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Verilen bayt dizisini kullanıcı seçimiyle veya güvenli platform dizinine kaydeder.
  /// Kullanıcı dosya diyaloğunu iptal ederse güvenle `null` döner.
  static Future<String?> saveBytes({
    required List<int> bytes,
    required String suggestedName,
    required String extension,
    required String mimeType,
    String? dialogTitle,
  }) async {
    final cleanExtension = extension.startsWith('.') ? extension.substring(1) : extension;
    final safeName = _ensureExtension(sanitizeFileName(suggestedName), cleanExtension);

    String? targetPath;

    // 1. Aşama: Masaüstü / Desteklenen ortamlarda sistem dosya kaydetme diyaloğunu dene
    try {
      final result = await getSaveLocation(
        suggestedName: safeName,
        confirmButtonText: dialogTitle ?? 'Kaydet',
        acceptedTypeGroups: <XTypeGroup>[
          XTypeGroup(
            label: cleanExtension.toUpperCase(),
            extensions: <String>[cleanExtension],
            mimeTypes: mimeType.isNotEmpty ? <String>[mimeType] : null,
          ),
        ],
        canCreateDirectories: true,
      );

      // Kullanıcı pencereyi kapattıysa veya "Vazgeç" dediyse:
      if (result == null) {
        return null;
      }
      targetPath = result.path;
    } on UnimplementedError {
      // file_selector bu platformda getSaveLocation desteklemiyorsa yerel dizine yaz
      targetPath = await _getFallbackFilePath(safeName);
    } catch (_) {
      // Diğer diyalog istisnalarında yerel fallback dizinini dene
      targetPath = await _getFallbackFilePath(safeName);
    }

    if (targetPath.isEmpty) {
      return null;
    }

    targetPath = _ensureExtension(targetPath, cleanExtension);

    // 2. Aşama: Dosyayı güvenli bir şekilde diske yaz
    try {
      final file = File(targetPath);
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 32 || e.message.contains('used by another process')) {
        throw StateError(
          'Dosya başka bir program (Excel, Word vb.) tarafından kullanılıyor. '
          'Lütfen açık olan belgeyi kapatıp tekrar deneyiniz.',
        );
      }
      rethrow;
    }
  }

  /// Platform diyalog desteği olmadığında (örn. Mobil) yedek kayıt yolu üretir.
  static Future<String> _getFallbackFilePath(String fileName) async {
    Directory? dir;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      }
    } catch (_) {
      dir = await getApplicationDocumentsDirectory();
    }

    var candidate = File(p.join(dir.path, fileName));
    if (!await candidate.exists()) {
      return candidate.path;
    }

    final baseName = p.basenameWithoutExtension(fileName);
    final ext = p.extension(fileName);
    int counter = 1;
    while (await candidate.exists()) {
      candidate = File(p.join(dir.path, '$baseName ($counter)$ext'));
      counter++;
    }
    return candidate.path;
  }

  static String _ensureExtension(String path, String extension) {
    final normalized = '.$extension';
    if (path.toLowerCase().endsWith(normalized.toLowerCase())) {
      return path;
    }
    return '$path$normalized';
  }
}
