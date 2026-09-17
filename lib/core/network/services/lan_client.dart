import 'dart:convert';
import 'dart:io';

import '../models/lan_health_result.dart';
import '../models/lan_sync_payload.dart';
import '../utils/network_utils.dart';

class LanClient {
  final HttpClient _httpClient;

  LanClient([HttpClient? client]) : _httpClient = client ?? HttpClient() {
    _httpClient.connectionTimeout = const Duration(seconds: 5);
  }

  /// Pings the LAN server to check availability and measure latency.
  Future<LanHealthResult> checkHealth({
    required String host,
    required int port,
    required String token,
  }) async {
    final sw = Stopwatch()..start();
    try {
      final baseUrl = NetworkUtils.formatBaseUrl(host, port);
      final uri = Uri.parse('$baseUrl/api/health');

      final request = await _httpClient.getUrl(uri).timeout(const Duration(seconds: 5));
      request.headers.set('X-PGYS-Token', token);
      request.headers.set('Accept', 'application/json');

      final response = await request.close().timeout(const Duration(seconds: 5));
      sw.stop();
      final ping = sw.elapsedMilliseconds;

      if (response.statusCode == HttpStatus.ok) {
        final content = await utf8.decoder.bind(response).join();
        final json = jsonDecode(content) as Map<String, dynamic>;
        return LanHealthResult.success(
          pingMs: ping,
          appName: json['appName'] as String? ?? 'PGYS',
          schemaVersion: json['schemaVersion'] as int? ?? 10,
          serverTime: json['serverTime'] != null
              ? DateTime.tryParse(json['serverTime'] as String)
              : null,
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return LanHealthResult.failure(
          pingMs: ping,
          errorMessage: 'Yetkisiz erişim: Güvenlik anahtarı (Token) uyuşmuyor.',
        );
      } else {
        return LanHealthResult.failure(
          pingMs: ping,
          errorMessage: 'Sunucu yanıt kodu: ${response.statusCode}',
        );
      }
    } on SocketException catch (_) {
      sw.stop();
      return LanHealthResult.failure(
        pingMs: sw.elapsedMilliseconds,
        errorMessage: 'Sunucuya ulaşılamadı ($host:$port). IP adresini ve sunucunun çalıştığını kontrol edin.',
      );
    } on HttpException catch (e) {
      sw.stop();
      return LanHealthResult.failure(
        pingMs: sw.elapsedMilliseconds,
        errorMessage: 'HTTP Protokol hatası: ${e.message}',
      );
    } catch (e) {
      sw.stop();
      return LanHealthResult.failure(
        pingMs: sw.elapsedMilliseconds,
        errorMessage: 'Bağlantı hatası: $e',
      );
    }
  }

  /// Fetches complete database tables from the LAN server.
  Future<LanSyncPayload> fetchSyncData({
    required String host,
    required int port,
    required String token,
  }) async {
    final baseUrl = NetworkUtils.formatBaseUrl(host, port);
    final uri = Uri.parse('$baseUrl/api/sync/tables');

    final request = await _httpClient.getUrl(uri).timeout(const Duration(seconds: 15));
    request.headers.set('X-PGYS-Token', token);
    request.headers.set('Accept', 'application/json');

    final response = await request.close().timeout(const Duration(seconds: 15));

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Sunucudan veri çekilemedi (HTTP ${response.statusCode})');
    }

    final content = await utf8.decoder.bind(response).join();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return LanSyncPayload.fromJson(json);
  }

  /// Pushes local table records to the central LAN server.
  Future<bool> pushSyncData({
    required String host,
    required int port,
    required String token,
    required LanSyncPayload payload,
  }) async {
    final baseUrl = NetworkUtils.formatBaseUrl(host, port);
    final uri = Uri.parse('$baseUrl/api/sync/push');

    final request = await _httpClient.postUrl(uri).timeout(const Duration(seconds: 20));
    request.headers.set('X-PGYS-Token', token);
    request.headers.set('Content-Type', 'application/json; charset=utf-8');

    final jsonString = jsonEncode(payload.toJson());
    request.write(jsonString);

    final response = await request.close().timeout(const Duration(seconds: 20));
    return response.statusCode == HttpStatus.ok;
  }

  /// Downloads raw SQLite database snapshot from the central server.
  Future<bool> downloadDatabase({
    required String host,
    required int port,
    required String token,
    required File targetFile,
  }) async {
    final baseUrl = NetworkUtils.formatBaseUrl(host, port);
    final uri = Uri.parse('$baseUrl/api/sync/download-db');

    final request = await _httpClient.getUrl(uri).timeout(const Duration(seconds: 30));
    request.headers.set('X-PGYS-Token', token);

    final response = await request.close().timeout(const Duration(seconds: 30));
    if (response.statusCode != HttpStatus.ok) {
      return false;
    }

    final sink = targetFile.openWrite();
    await response.pipe(sink);
    return true;
  }

  void close() {
    _httpClient.close(force: true);
  }
}
