import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

class ServerConfig {
  final int port;
  final String authToken;
  final String? adminToken;
  final String? dbPath;

  const ServerConfig({
    this.port = 8085,
    this.authToken = '',
    this.adminToken,
    this.dbPath,
  });

  /// Generates a cryptographically secure random token of at least 32 characters.
  static String generateSecureToken([int length = 32]) {
    final tokenLength = length < 32 ? 32 : length;
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(tokenLength, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Default server configuration file path on disk (C:\ProgramData\PGYS\server_config.json).
  static File get defaultConfigFile {
    final programData = Platform.isWindows
        ? (Platform.environment['PROGRAMDATA'] ?? r'C:\ProgramData')
        : (Platform.environment['HOME'] ?? '.');
    return File(p.join(programData, 'PGYS', 'server_config.json'));
  }

  Map<String, dynamic> toJson() {
    return {
      'serverPort': port,
      'authToken': authToken,
      if (adminToken != null) 'adminToken': adminToken,
      if (dbPath != null) 'dbPath': dbPath,
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      port: (json['serverPort'] ?? json['port']) as int? ?? 8085,
      authToken: json['authToken'] as String? ?? '',
      adminToken: json['adminToken'] as String?,
      dbPath: json['dbPath'] as String?,
    );
  }

  /// Loads configuration from JSON file on disk.
  static Future<ServerConfig?> loadFromFile([File? file]) async {
    try {
      final f = file ?? defaultConfigFile;
      if (await f.exists()) {
        final content = await f.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        return ServerConfig.fromJson(json);
      }
    } catch (_) {}
    return null;
  }

  /// Saves configuration to JSON file on disk.
  Future<void> saveToFile([File? file]) async {
    try {
      final f = file ?? defaultConfigFile;
      if (!f.parent.existsSync()) {
        f.parent.createSync(recursive: true);
      }
      await f.writeAsString(
        const JsonEncoder.withIndent('  ').convert(toJson()),
      );
    } catch (_) {}
  }
}
