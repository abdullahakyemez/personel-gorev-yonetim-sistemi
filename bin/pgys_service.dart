import 'dart:async';
import 'dart:ffi';
import 'dart:io';


import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/models/server_config.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_client.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/services/lan_server.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/utils/network_utils.dart';
import 'package:sqlite3/open.dart';


const String _serviceTaskName = 'PGYS_LanService';

void main(List<String> args) async {
  _initSqlite3();

  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    exit(0);
  }

  if (args.contains('--install')) {
    await _installService();
    exit(exitCode);
  }

  if (args.contains('--uninstall')) {
    await _uninstallService();
    exit(exitCode);
  }

  if (args.contains('--start')) {
    await _startService();
    exit(exitCode);
  }

  if (args.contains('--stop')) {
    await _stopService();
    exit(exitCode);
  }

  if (args.contains('--status')) {
    await _checkStatus();
    exit(exitCode);
  }

  // Default mode or --run-service: Run as server process
  await _runServer(args);
}


void _initSqlite3() {
  if (Platform.isWindows) {
    open.overrideFor(OperatingSystem.windows, () {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final candidates = [
        p.join(exeDir, 'sqlite3.dll'),
        p.join(exeDir, 'data', 'flutter_assets', 'sqlite3.dll'),
        'sqlite3.dll',
      ];
      for (final path in candidates) {
        if (File(path).existsSync()) {
          try {
            return DynamicLibrary.open(path);
          } catch (_) {}
        }
      }
      return DynamicLibrary.open('sqlite3.dll');
    });
  }
}

void _printHelp() {
  stdout.writeln('========================================================');
  stdout.writeln('PGYS Merkez Ağ ve Senkronizasyon Windows Servisi');
  stdout.writeln('Personel ve Görev Yönetim Sistemi - Arka Plan Servis Konsolu');
  stdout.writeln('========================================================');
  stdout.writeln('');
  stdout.writeln('Kullanım:');
  stdout.writeln('  pgys_service.exe [seçenekler]');
  stdout.writeln('');
  stdout.writeln('Komutlar:');
  stdout.writeln('  --run-service      Sunucuyu arka plan servisi / konsol olarak çalıştırır (varsayılan).');
  stdout.writeln('  --install          Windows Sistem Servisi (Görev Zamanlayıcı ONSTART) olarak kaydeder.');
  stdout.writeln('  --uninstall        Kayıtlı Windows servisini kaldırır.');
  stdout.writeln('  --start            Kayıtlı Windows servisini başlatır.');
  stdout.writeln('  --stop             Çalışan Windows servisini durdurur.');
  stdout.writeln('  --status           Sunucunun aktiflik ve bağlantı durumunu kontrol eder.');
  stdout.writeln('  --help, -h         Bu yardım metnini gösterir.');
  stdout.writeln('');
  stdout.writeln('Parametreler:');
  stdout.writeln('  --port=<port>      Dinleme portu (varsayılan: 8085)');
  stdout.writeln('  --token=<token>    Ağ güvenlik anahtarı');
  stdout.writeln('  --db-path=<yol>    Veritabanı sqlite dosya yolu');
  stdout.writeln('');
}

Future<void> _runServer(List<String> args) async {
  stdout.writeln('[PGYS Service] Sunucu ortamı hazırlanıyor...');

  // 1. Load config from file or defaults
  final fileConfig = await ServerConfig.loadFromFile();
  var port = fileConfig?.port ?? 8085;
  var token = fileConfig?.authToken ?? '';
  var adminToken = fileConfig?.adminToken;
  String? customDbPath = fileConfig?.dbPath;

  for (final arg in args) {
    if (arg.startsWith('--port=')) {
      port = int.tryParse(arg.substring(7)) ?? port;
    } else if (arg.startsWith('--token=')) {
      token = arg.substring(8);
    } else if (arg.startsWith('--admin-token=')) {
      adminToken = arg.substring(14);
    } else if (arg.startsWith('--db-path=')) {
      customDbPath = arg.substring(10);
    }
  }

  if (token.isEmpty) {
    token = ServerConfig.generateSecureToken(32);
    stdout.writeln('[PGYS Service] Yeni ağ güvenlik anahtarı oluşturuldu.');
  }

  // Ensure config file exists on disk
  final activeConfig = ServerConfig(
    port: port,
    authToken: token,
    adminToken: adminToken,
    dbPath: customDbPath,
  );
  await activeConfig.saveToFile();


  // 2. Resolve database file
  File dbFile;
  if (customDbPath != null && customDbPath.isNotEmpty) {
    dbFile = File(customDbPath);
  } else {
    dbFile = AppDatabase.sharedDatabaseFile;
  }

  if (!dbFile.parent.existsSync()) {
    dbFile.parent.createSync(recursive: true);
  }

  stdout.writeln('[PGYS Service] Veritabanı dosyası: ${dbFile.path}');

  final database = AppDatabase(NativeDatabase(dbFile));
  final server = LanServer(
    database,
    authToken: token,
    adminToken: adminToken,
  );

  final success = await server.start(
    port: port,
    authToken: token,
    adminToken: adminToken,
  );

  if (!success) {
    stderr.writeln('[PGYS Service] HATA: Sunucu $port portunda başlatılamadı! Port kullanımda olabilir.');
    exitCode = 1;
    return;
  }

  final ips = await NetworkUtils.getLocalIpv4Addresses();
  stdout.writeln('========================================================');
  stdout.writeln('PGYS MERKEZ SUNUCU AKTİF (7/24 ARKA PLAN)');
  stdout.writeln('Port: $port');
  stdout.writeln('Güvenlik Anahtarı (Token): $token');
  stdout.writeln('Ağ IP Adresleri: ${ips.join(', ')}');
  stdout.writeln('WebSocket Canlı Senkronizasyon: Aktif (/api/ws)');
  stdout.writeln('Çıkmak ve durdurmak için CTRL+C tuşlarına basabilirsiniz.');
  stdout.writeln('========================================================');

  // Handle graceful shutdown
  final completer = Completer<void>();

  ProcessSignal.sigint.watch().listen((_) async {
    stdout.writeln('\n[PGYS Service] Kapatma sinyali (SIGINT) alındı. Sunucu durduruluyor...');
    await server.stop();
    await database.close();
    stdout.writeln('[PGYS Service] Güvenli bir şekilde durduruldu.');
    completer.complete();
  });

  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) async {
      stdout.writeln('\n[PGYS Service] Kapatma sinyali (SIGTERM) alındı.');
      await server.stop();
      await database.close();
      completer.complete();
    });
  }

  await completer.future;
}

Future<void> _installService() async {
  if (!Platform.isWindows) {
    stderr.writeln('Hata: Windows Servis kurulumu yalnızca Windows işletim sisteminde desteklenir.');
    exitCode = 1;
    return;
  }

  final exePath = Platform.resolvedExecutable;
  stdout.writeln('[Kurulum] Windows Servisi (Görev Zamanlayıcı ONSTART) kaydediliyor...');
  stdout.writeln('[Kurulum] Çalıştırılacak dosya: $exePath');

  // schtasks /create /tn "PGYS_LanService" /tr "\"<exePath>\" --run-service" /sc onstart /ru "SYSTEM" /rl highest /f
  final result = await Process.run(
    'schtasks.exe',
    [
      '/create',
      '/tn',
      _serviceTaskName,
      '/tr',
      '"$exePath" --run-service',
      '/sc',
      'onstart',
      '/ru',
      'SYSTEM',
      '/rl',
      'highest',
      '/f',
    ],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    stdout.writeln('[Kurulum Başarılı] $_serviceTaskName servisi Windows açılışına başarıyla eklendi.');
    stdout.writeln('[Kurulum] Servis şimdi başlatılıyor...');
    await _startService();
  } else {
    stderr.writeln('[Kurulum Hatası] Servis kaydedilemedi (Yönetici yetkisi gerekebilir):');
    stderr.writeln(result.stderr);
    stderr.writeln(result.stdout);
    exitCode = result.exitCode;
  }
}

Future<void> _uninstallService() async {
  if (!Platform.isWindows) return;

  stdout.writeln('[Kaldırma] $_serviceTaskName servisi durduruluyor ve siliniyor...');
  await Process.run('schtasks.exe', ['/end', '/tn', _serviceTaskName], runInShell: true);
  final result = await Process.run('schtasks.exe', ['/delete', '/tn', _serviceTaskName, '/f'], runInShell: true);

  if (result.exitCode == 0) {
    stdout.writeln('[Başarılı] $_serviceTaskName servisi başarıyla sistemden kaldırıldı.');
  } else {
    stderr.writeln('[Bilgi/Hata] Servis silinemedi veya zaten kayıtlı değil: ${result.stderr}');
  }
}

Future<void> _startService() async {
  if (!Platform.isWindows) return;

  final result = await Process.run('schtasks.exe', ['/run', '/tn', _serviceTaskName], runInShell: true);
  if (result.exitCode == 0) {
    stdout.writeln('[Başarılı] $_serviceTaskName servisi başlatıldı.');
  } else {
    stderr.writeln('[Hata] Servis başlatılamadı: ${result.stderr}');
    exitCode = result.exitCode;
  }
}

Future<void> _stopService() async {
  if (!Platform.isWindows) return;

  final result = await Process.run('schtasks.exe', ['/end', '/tn', _serviceTaskName], runInShell: true);
  if (result.exitCode == 0) {
    stdout.writeln('[Başarılı] $_serviceTaskName servisi durduruldu.');
  } else {
    stderr.writeln('[Hata] Servis durdurulamadı: ${result.stderr}');
  }
}

Future<void> _checkStatus() async {
  final cfg = await ServerConfig.loadFromFile();
  final port = cfg?.port ?? 8085;
  final token = cfg?.authToken ?? '';


  stdout.writeln('[Durum Kontrolü] Sunucu test ediliyor (127.0.0.1:$port)...');

  final client = LanClient();
  final res = await client.checkHealth(
    host: '127.0.0.1',
    port: port,
    token: token,
  );
  client.close();

  if (res.isSuccess) {
    stdout.writeln('========================================================');
    stdout.writeln('DURUM: PGYS MERKEZ SUNUCU ÇALIŞIYOR');
    stdout.writeln('Port: $port');
    stdout.writeln('Yanıt Süresi (Ping): ${res.pingMs} ms');
    stdout.writeln('Uygulama: ${res.appName}');
    stdout.writeln('Şema Versiyonu: ${res.schemaVersion}');
    stdout.writeln('Sunucu Saati: ${res.serverTime}');
    stdout.writeln('========================================================');
  } else {
    stdout.writeln('========================================================');
    stdout.writeln('DURUM: PGYS MERKEZ SUNUCU KAPALI VEYA ULAŞILAMIYOR');
    stdout.writeln('Port: $port');
    stdout.writeln('Hata: ${res.errorMessage}');
    stdout.writeln('========================================================');
  }
}
