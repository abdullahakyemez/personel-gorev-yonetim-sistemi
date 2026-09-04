import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

class ExportFileService {
  const ExportFileService._();

  static Future<String?> saveBytes({
    required List<int> bytes,
    required String suggestedName,
    required String extension,
    required String mimeType,
    String? dialogTitle,
  }) async {
    final cleanExtension = extension.startsWith('.') ? extension.substring(1) : extension;
    final result = await getSaveLocation(
      suggestedName: suggestedName,
      confirmButtonText: dialogTitle ?? 'Kaydet',
      acceptedTypeGroups: <XTypeGroup>[
        XTypeGroup(
          label: cleanExtension.toUpperCase(),
          extensions: <String>[cleanExtension],
        ),
      ],
      canCreateDirectories: true,
    );

    if (result == null) return null;

    final file = XFile.fromData(
      Uint8List.fromList(bytes),
      name: suggestedName,
      mimeType: mimeType,
    );
    await file.saveTo(_ensureExtension(result.path, cleanExtension));
    return _ensureExtension(result.path, cleanExtension);
  }

  static String _ensureExtension(String path, String extension) {
    final normalized = '.$extension';
    if (path.toLowerCase().endsWith(normalized.toLowerCase())) {
      return path;
    }
    return '$path$normalized';
  }
}
