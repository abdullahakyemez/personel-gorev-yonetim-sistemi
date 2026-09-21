import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';

class LanServer {
  static final Logger _logger = Logger();
  final AppDatabase database;
  HttpServer? _server;
  int? _port;
  String authToken;
  String? adminToken;

  LanServer(this.database, {this.authToken = '', this.adminToken});

  bool get isRunning => _server != null;
  int? get port => _server?.port ?? _port;

  /// Starts the HTTP server on [port] bound to all IPv4 interfaces.
  Future<bool> start({
    int port = 8085,
    String? authToken,
    String? adminToken,
  }) async {
    final effectiveToken = authToken ?? this.authToken;
    final effectiveAdmin = adminToken ?? this.adminToken;

    if (_server != null) {
      if ((_port == port || port == 0) &&
          this.authToken == effectiveToken &&
          this.adminToken == effectiveAdmin) {
        return true;
      }
      await stop();
    }

    try {
      this.authToken = effectiveToken;
      this.adminToken = effectiveAdmin;
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      _port = _server!.port;
      _server!.listen(
        _handleRequest,
        onError: (err, stackTrace) {
          _logger.e('HttpServer dinleme hatası: $err', error: err, stackTrace: stackTrace);
        },
        cancelOnError: false,
      );
      return true;
    } catch (e, stackTrace) {
      _logger.e('HttpServer başlatma hatası: $e', error: e, stackTrace: stackTrace);
      _server = null;
      return false;
    }
  }

  /// Stops the running HTTP server.
  Future<void> stop() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final response = request.response;

    // Set CORS headers
    response.headers.set('Access-Control-Allow-Origin', '*');
    response.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    response.headers.set(
      'Access-Control-Allow-Headers',
      'Origin, Content-Type, X-PGYS-Token, X-PGYS-Admin-Token',
    );

    if (request.method == 'OPTIONS') {
      response.statusCode = HttpStatus.ok;
      await response.close();
      return;
    }

    // Validate Auth Token
    if (!_verifyToken(request)) {
      _sendError(response, HttpStatus.unauthorized, 'Yetkisiz erişim: Geçersiz ağ anahtarı (X-PGYS-Token).');
      return;
    }

    final path = request.uri.path;
    try {
      if (request.method == 'GET' && path == '/api/health') {
        await _handleHealth(request, response);
      } else if (request.method == 'GET' && path == '/api/sync/tables') {
        await _handleGetTables(request, response);
      } else if (request.method == 'POST' && path == '/api/sync/push') {
        await _handlePushTables(request, response);
      } else if (request.method == 'GET' && path == '/api/sync/download-db') {
        await _handleDownloadDb(request, response);
      } else {
        _sendError(response, HttpStatus.notFound, 'Endpoint bulunamadı: $path');
      }
    } catch (e, stackTrace) {
      _logger.e('LAN sunucu istek işleme hatası: $e', error: e, stackTrace: stackTrace);
      _sendError(response, HttpStatus.internalServerError, 'Sunucu hatası oluştu.');
    }
  }

  /// Performs a constant-time comparison of two strings to prevent timing attacks.
  static bool constantTimeEquals(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);

    if (aBytes.isEmpty || bBytes.isEmpty) {
      return aBytes.isEmpty && bBytes.isEmpty;
    }

    var result = aBytes.length ^ bBytes.length;
    final length = aBytes.length < bBytes.length ? aBytes.length : bBytes.length;

    for (var i = 0; i < length; i++) {
      result |= aBytes[i] ^ bBytes[i];
    }

    return result == 0;
  }

  bool _constantTimeEquals(String a, String b) => constantTimeEquals(a, b);

  bool _verifyToken(HttpRequest request) {
    if (authToken.isEmpty) {
      return false;
    }
    final headerToken = request.headers.value('x-pgys-token');
    if (headerToken != null && _constantTimeEquals(headerToken, authToken)) {
      return true;
    }
    final queryToken = request.uri.queryParameters['token'];
    if (queryToken != null && _constantTimeEquals(queryToken, authToken)) {
      return true;
    }
    return false;
  }

  bool _verifyAdminToken(HttpRequest request) {
    final admin = adminToken;
    if (admin == null || admin.isEmpty) {
      return false;
    }
    final headerToken = request.headers.value('x-pgys-admin-token');
    if (headerToken != null && _constantTimeEquals(headerToken, admin)) {
      return true;
    }
    final queryToken = request.uri.queryParameters['admin_token'];
    if (queryToken != null && _constantTimeEquals(queryToken, admin)) {
      return true;
    }
    return false;
  }

  Future<void> _handleHealth(HttpRequest request, HttpResponse response) async {
    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    final body = jsonEncode({
      'status': 'ok',
      'serverTime': DateTime.now().toIso8601String(),
      'appName': 'PGYS',
      'schemaVersion': 10,
      'mode': 'server',
    });
    response.write(body);
    await response.close();
  }

  Future<void> _handleGetTables(HttpRequest request, HttpResponse response) async {
    final users = await _getTableData('user_table');
    final personnel = await _getTableData('personnel_table');
    final tasks = await _getTableData('task_table');
    final taskPersonnel = await _getTableData('task_personnel_table');
    final leave = await _getTableData('leave_table');
    final personnelHistory = await _getTableData('personnel_history_table');
    final settings = await _getTableData('settings_table');

    final payload = LanSyncPayload(
      timestamp: DateTime.now(),
      schemaVersion: 10,
      users: users,
      personnel: personnel,
      tasks: tasks,
      taskPersonnel: taskPersonnel,
      leave: leave,
      personnelHistory: personnelHistory,
      settings: settings,
    );

    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(payload.toJson()));
    await response.close();
  }

  Future<void> _handlePushTables(HttpRequest request, HttpResponse response) async {
    final content = await utf8.decoder.bind(request).join();
    if (content.isEmpty) {
      _sendError(response, HttpStatus.badRequest, 'Boş istek gövdesi.');
      return;
    }

    final json = jsonDecode(content) as Map<String, dynamic>;
    final payload = LanSyncPayload.fromJson(json);

    if (payload.users.isNotEmpty) {
      if (!_verifyAdminToken(request)) {
        _sendError(
          response,
          HttpStatus.forbidden,
          'Yetkisiz işlem: Kullanıcı tablosu (user_table) senkronizasyonu için yönetici yetkisi (X-PGYS-Admin-Token) gereklidir.',
        );
        return;
      }
    }

    await database.transaction(() async {
      await database.customStatement('PRAGMA foreign_keys = OFF;');

      if (payload.settings.isNotEmpty) {
        await _applyTableData('settings_table', payload.settings);
      }
      if (payload.personnel.isNotEmpty) {
        await _applyTableData('personnel_table', payload.personnel);
      }
      if (payload.users.isNotEmpty) {
        await _applyTableData('user_table', payload.users);
      }
      if (payload.tasks.isNotEmpty) {
        await _applyTableData('task_table', payload.tasks);
      }
      if (payload.taskPersonnel.isNotEmpty) {
        await _applyTableData('task_personnel_table', payload.taskPersonnel);
      }
      if (payload.leave.isNotEmpty) {
        await _applyTableData('leave_table', payload.leave);
      }
      if (payload.personnelHistory.isNotEmpty) {
        await _applyTableData('personnel_history_table', payload.personnelHistory);
      }

      await database.customStatement('PRAGMA foreign_keys = ON;');
    });

    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode({
      'success': true,
      'appliedRecords': payload.totalRecordCount,
      'timestamp': DateTime.now().toIso8601String(),
    }));
    await response.close();
  }

  Future<void> _handleDownloadDb(HttpRequest request, HttpResponse response) async {
    File? tempFile;
    try {
      final tempDir = Directory.systemTemp;
      final tempPath = p.join(
        tempDir.path,
        'pgys_lan_download_${DateTime.now().millisecondsSinceEpoch}.sqlite',
      );
      tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      final normalized = tempPath.replaceAll(r'\', '/');
      await database.customStatement('VACUUM INTO ?;', [normalized]);
      final bytes = await tempFile.readAsBytes();

      response.statusCode = HttpStatus.ok;
      response.headers.contentType = ContentType('application', 'x-sqlite3');
      response.headers.set(
        'Content-Disposition',
        'attachment; filename="pgys_lan_sync.sqlite"',
      );
      response.contentLength = bytes.length;
      response.add(bytes);
      await response.close();
    } catch (e, stackTrace) {
      _logger.e('Veritabanı snapshot hatası: $e', error: e, stackTrace: stackTrace);
      _sendError(response, HttpStatus.internalServerError, 'Sunucu hatası oluştu.');
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getTableData(String tableName) async {
    try {
      final rows = await database.customSelect('SELECT * FROM $tableName;').get();
      return rows.map((r) => Map<String, dynamic>.from(r.data)).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _applyTableData(String tableName, List<Map<String, dynamic>> rows) async {
    for (final row in rows) {
      if (row.isEmpty) continue;
      final keys = row.keys.toList();
      final columns = keys.map((k) => '"$k"').join(', ');
      final placeholders = List.filled(keys.length, '?').join(', ');
      final values = keys.map((k) => row[k]).toList();

      await database.customStatement(
        'INSERT OR REPLACE INTO $tableName ($columns) VALUES ($placeholders);',
        values,
      );
    }
  }

  void _sendError(HttpResponse response, int statusCode, String message) {
    if (statusCode >= HttpStatus.internalServerError) {
      _logger.e('LAN Sunucu Hata Yanıtı ($statusCode): $message');
    }
    response.statusCode = statusCode;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode({'error': message, 'statusCode': statusCode}));
    response.close();
  }
}
