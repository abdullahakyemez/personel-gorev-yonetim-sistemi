import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../database/app_database.dart';
import '../models/lan_sync_payload.dart';
import 'lan_discovery_service.dart';
import 'lan_sync_applier.dart';

class LanServer {
  static final Logger _logger = Logger();
  final AppDatabase database;
  late final LanSyncApplier _syncApplier;
  HttpServer? _server;
  LanDiscoveryAdvertiser? _discoveryAdvertiser;
  int? _port;
  String authToken;
  String? adminToken;
  final Map<String, List<DateTime>> _failedAttemptsByIp = {};
  final Map<WebSocket, String?> _connectedClients = {};

  LanServer(this.database, {this.authToken = '', this.adminToken})
      : _syncApplier = LanSyncApplier(database);

  bool get isRunning => _server != null;
  int? get port => _server?.port ?? _port;
  int get connectedClientCount => _connectedClients.length;

  /// Broadcasts an event to all connected WebSocket clients.
  /// Optionally excludes the client matching [excludeClientId].
  int broadcast(
    String eventType, {
    Map<String, dynamic>? data,
    String? excludeClientId,
  }) {
    if (_connectedClients.isEmpty) return 0;

    final payload = jsonEncode({
      'type': eventType,
      'data': data ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });

    final deadSockets = <WebSocket>[];
    var sentCount = 0;

    for (final entry in _connectedClients.entries) {
      final socket = entry.key;
      final clientId = entry.value;

      if (excludeClientId != null &&
          clientId != null &&
          clientId == excludeClientId) {
        continue;
      }

      try {
        socket.add(payload);
        sentCount++;
      } catch (_) {
        deadSockets.add(socket);
      }
    }

    for (final s in deadSockets) {
      _connectedClients.remove(s);
    }

    return sentCount;
  }

  /// Triggers a 'data_changed' broadcast event to all clients.
  void notifyDataChanged({String source = 'server'}) {
    if (isRunning) {
      broadcast('data_changed', data: {'source': source});
    }
  }


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

      // Start UDP discovery advertiser
      _discoveryAdvertiser = LanDiscoveryAdvertiser(serverPort: _port!);
      await _discoveryAdvertiser?.start();

      return true;
    } catch (e, stackTrace) {
      _logger.e('HttpServer başlatma hatası: $e', error: e, stackTrace: stackTrace);
      _server = null;
      return false;
    }
  }

  /// Stops the running HTTP server.
  Future<void> stop() async {
    _discoveryAdvertiser?.stop();
    _discoveryAdvertiser = null;

    for (final socket in _connectedClients.keys) {
      try {
        await socket.close(WebSocketStatus.normalClosure, 'Sunucu durduruldu');
      } catch (_) {}
    }
    _connectedClients.clear();

    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
    }
  }


  bool _isRateLimited(String ip) {
    final now = DateTime.now();
    final attempts = _failedAttemptsByIp[ip];
    if (attempts == null) return false;
    attempts.removeWhere((dt) => now.difference(dt).inSeconds > 60);
    return attempts.length >= 10;
  }

  void _recordFailedAttempt(String ip) {
    final now = DateTime.now();
    final attempts = _failedAttemptsByIp.putIfAbsent(ip, () => []);
    attempts.add(now);
  }

  void _resetFailedAttempts(String ip) {
    _failedAttemptsByIp.remove(ip);
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final response = request.response;

    // Set CORS and security headers
    response.headers.set('Access-Control-Allow-Origin', '*');
    response.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    response.headers.set(
      'Access-Control-Allow-Headers',
      'Origin, Content-Type, X-PGYS-Token, X-PGYS-Admin-Token',
    );
    response.headers.set('X-Content-Type-Options', 'nosniff');
    response.headers.set('X-Frame-Options', 'DENY');

    if (request.method == 'OPTIONS') {
      response.statusCode = HttpStatus.ok;
      await response.close();
      return;
    }

    final clientIp = request.connectionInfo?.remoteAddress.address ?? 'unknown';

    if (_isRateLimited(clientIp)) {
      _sendError(
        response,
        HttpStatus.tooManyRequests,
        'Çok fazla başarısız güvenlik anahtarı denemesi. Lütfen 1 dakika sonra tekrar deneyin.',
      );
      return;
    }

    // Validate Auth Token
    if (!_verifyToken(request)) {
      _recordFailedAttempt(clientIp);
      _sendError(response, HttpStatus.unauthorized, 'Yetkisiz erişim: Geçersiz ağ anahtarı (X-PGYS-Token).');
      return;
    }

    _resetFailedAttempts(clientIp);

    final path = request.uri.path;
    try {
      if (path == '/api/ws' && WebSocketTransformer.isUpgradeRequest(request)) {
        await _handleWebSocket(request);
      } else if (request.method == 'GET' && path == '/api/health') {
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

  Future<void> _handleWebSocket(HttpRequest request) async {
    try {
      final clientId = request.headers.value('x-pgys-client-id') ??
          request.uri.queryParameters['client_id'] ??
          request.uri.queryParameters['clientId'];

      final socket = await WebSocketTransformer.upgrade(request);
      _connectedClients[socket] = clientId;
      _logger.i(
        'Yeni WebSocket istemcisi bağlandı (ID: $clientId, IP: ${request.connectionInfo?.remoteAddress.address}). '
        'Toplam bağlı: ${_connectedClients.length}',
      );

      socket.listen(
        (message) {
          try {
            final data = jsonDecode(message.toString());
            if (data is Map && data['type'] == 'ping') {
              socket.add(jsonEncode({
                'type': 'pong',
                'timestamp': DateTime.now().toIso8601String(),
              }));
            }
          } catch (_) {}
        },
        onError: (err) {
          _logger.w('WebSocket istemci hatası: $err');
          _connectedClients.remove(socket);
        },
        onDone: () {
          _connectedClients.remove(socket);
          _logger.i('WebSocket istemci ayrıldı (ID: $clientId). Kalan: ${_connectedClients.length}');
        },
        cancelOnError: true,
      );
    } catch (e, stackTrace) {
      _logger.e('WebSocket yükseltme hatası: $e', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _handleHealth(HttpRequest request, HttpResponse response) async {

    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    final body = jsonEncode({
      'status': 'ok',
      'serverTime': DateTime.now().toIso8601String(),
      'appName': 'PGYS',
      'schemaVersion': database.schemaVersion,
      'mode': 'server',
    });
    response.write(body);
    await response.close();
  }

  Future<void> _handleGetTables(HttpRequest request, HttpResponse response) async {
    final payload = await _syncApplier.createSyncPayload();
    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(payload.toJson()));
    await response.close();
  }

  Future<void> _handlePushTables(HttpRequest request, HttpResponse response) async {
    const maxPayloadBytes = 50 * 1024 * 1024; // 50 MB
    var totalBytes = 0;
    final buffer = BytesBuilder(copy: false);

    try {
      await for (final chunk in request) {
        totalBytes += chunk.length;
        if (totalBytes > maxPayloadBytes) {
          _sendError(
            response,
            HttpStatus.requestEntityTooLarge,
            'Yük boyutu izin verilen sınırı aşıyor (Maksimum 50 MB).',
          );
          return;
        }
        buffer.add(chunk);
      }
    } catch (e) {
      _sendError(response, HttpStatus.badRequest, 'İstek gövdesi okunamadı: $e');
      return;
    }

    final bytes = buffer.takeBytes();
    if (bytes.isEmpty) {
      _sendError(response, HttpStatus.badRequest, 'Boş istek gövdesi.');
      return;
    }

    final content = utf8.decode(bytes);
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

    final originClientId = request.headers.value('x-pgys-client-id') ??
        request.uri.queryParameters['client_id'] ??
        request.uri.queryParameters['clientId'];

    await _syncApplier.applyPayload(payload);

    // Bağlı diğer tüm istemcilere anında veritabanı değişikliğini bildir
    broadcast(
      'data_changed',
      data: {
        'source': 'client_push',
        'appliedRecords': payload.totalRecordCount,
      },
      excludeClientId: originClientId,
    );

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
