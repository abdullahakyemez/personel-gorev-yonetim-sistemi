import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';

class LanServer {
  final AppDatabase database;
  HttpServer? _server;
  int? _port;
  String _authToken = 'pgys-lan-secret';

  LanServer(this.database);

  bool get isRunning => _server != null;
  int? get port => _server?.port ?? _port;

  /// Starts the HTTP server on [port] bound to all IPv4 interfaces.
  Future<bool> start({int port = 8085, String authToken = 'pgys-lan-secret'}) async {
    if (_server != null) {
      if ((_port == port || port == 0) && _authToken == authToken) return true;
      await stop();
    }

    try {
      _authToken = authToken;
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      _port = _server!.port;
      _server!.listen(
        _handleRequest,
        onError: (err) {
          // Log or handle error
        },
        cancelOnError: false,
      );
      return true;
    } catch (e) {
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
    response.headers.set('Access-Control-Allow-Headers', 'Origin, Content-Type, X-PGYS-Token');

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
    } catch (e) {
      _sendError(response, HttpStatus.internalServerError, 'Sunucu hatası: $e');
    }
  }

  bool _verifyToken(HttpRequest request) {
    final headerToken = request.headers.value('x-pgys-token');
    if (headerToken != null && headerToken == _authToken) {
      return true;
    }
    final queryToken = request.uri.queryParameters['token'];
    if (queryToken != null && queryToken == _authToken) {
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
    } catch (e) {
      _sendError(response, HttpStatus.internalServerError, 'Veritabanı snapshot hatası: $e');
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
    response.statusCode = statusCode;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode({'error': message, 'statusCode': statusCode}));
    response.close();
  }
}
