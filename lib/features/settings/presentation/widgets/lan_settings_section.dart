import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/application/lan_network_provider.dart';
import '../../../../core/network/models/network_config.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/feedback/pgys_feedback.dart';

class LanSettingsSection extends ConsumerStatefulWidget {
  const LanSettingsSection({super.key});

  @override
  ConsumerState<LanSettingsSection> createState() => _LanSettingsSectionState();
}

class _LanSettingsSectionState extends ConsumerState<LanSettingsSection> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _tokenController;
  late TextEditingController _intervalController;
  bool _obscureToken = true;
  bool _autoSync = true;
  NetworkMode _selectedMode = NetworkMode.standalone;

  @override
  void initState() {
    super.initState();
    final netState = ref.read(lanNetworkProvider);
    _selectedMode = netState.config.mode;
    _hostController = TextEditingController(text: netState.config.serverHost);
    _portController = TextEditingController(text: netState.config.serverPort.toString());
    _tokenController = TextEditingController(text: netState.config.authToken);
    _intervalController = TextEditingController(text: netState.config.syncIntervalSeconds.toString());
    _autoSync = netState.config.autoSyncEnabled;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _tokenController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final netState = ref.watch(lanNetworkProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PGYS uygulamasını kurum içi kapalı yerel ağda tek bir ana bilgisayar üzerinden diğer bilgisayarlarla eşlenik olarak çalıştırabilirsiniz.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Çalışma Modu Seçimi
        SegmentedButton<NetworkMode>(
          segments: const [
            ButtonSegment(
              value: NetworkMode.standalone,
              label: Text('Tek PC (Yerel)'),
              icon: Icon(Icons.computer_rounded),
            ),
            ButtonSegment(
              value: NetworkMode.server,
              label: Text('Merkez Sunucu'),
              icon: Icon(Icons.dns_rounded),
            ),
            ButtonSegment(
              value: NetworkMode.client,
              label: Text('İstemci PC'),
              icon: Icon(Icons.lan_rounded),
            ),
          ],
          selected: {_selectedMode},
          onSelectionChanged: (newSelection) async {
            final mode = newSelection.first;
            setState(() => _selectedMode = mode);
            await ref.read(lanNetworkProvider.notifier).setMode(mode);
            if (!context.mounted) return;
            PGYSFeedback.showSuccess(
              context,
              'Çalışma modu "${mode.label}" olarak güncellendi.',
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        if (_selectedMode == NetworkMode.standalone)
          _buildStandaloneView(theme)
        else if (_selectedMode == NetworkMode.server)
          _buildServerView(theme, netState)
        else
          _buildClientView(theme, netState),
      ],
    );
  }

  Widget _buildStandaloneView(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Uygulama yalnızca bu bilgisayarda yerel olarak çalışmaktadır. Veriler başka cihazlarla paylaşılmaz.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerView(ThemeData theme, LanNetworkState netState) {
    final isRunning = netState.isServerRunning;
    final ips = netState.serverLocalIps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sunucu Durum Rozeti
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isRunning
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isRunning ? Colors.green : Colors.orange,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isRunning ? Icons.wifi_tethering_rounded : Icons.portable_wifi_off_rounded,
                color: isRunning ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRunning ? 'Sunucu Aktif ve Yayında' : 'Sunucu Durduruldu',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isRunning ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                    ),
                    Text(
                      isRunning
                          ? 'İstemci bilgisayarlar bu makineye bağlanabilir.'
                          : 'İstemci bağlantıları için sunucuyu başlatınız.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                icon: Icon(isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
                label: Text(isRunning ? 'Durdur' : 'Başlat'),
                style: FilledButton.styleFrom(
                  backgroundColor: isRunning ? Colors.red.shade100 : Colors.green.shade100,
                  foregroundColor: isRunning ? Colors.red.shade900 : Colors.green.shade900,
                ),
                onPressed: () async {
                  if (isRunning) {
                    await ref.read(lanNetworkProvider.notifier).stopServer();
                    if (!mounted) return;
                    PGYSFeedback.showWarning(context, 'Sunucu durduruldu.');
                  } else {
                    final success = await ref.read(lanNetworkProvider.notifier).startServer();
                    if (!mounted) return;
                    if (success) {
                      PGYSFeedback.showSuccess(context, 'Sunucu başarıyla başlatıldı.');
                    } else {
                      PGYSFeedback.showError(context, 'Sunucu başlatılamadı!');
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Bu Bilgisayarın IP Adresleri
        Text(
          'Bu Bilgisayarın Yerel IP Adresi (İstemcilere Girilecek Adres):',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ips.map((ip) {
            final fullAddress = '$ip:${_portController.text}';
            return ActionChip(
              avatar: const Icon(Icons.copy_rounded, size: 16),
              label: Text(fullAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: ip));
                PGYSFeedback.showInfo(context, '$ip panoya kopyalandı.');
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Port ve Token Ayarları
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Sunucu Portu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers_rounded),
                  helperText: 'Varsayılan: 8085',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _tokenController,
                obscureText: _obscureToken,
                decoration: InputDecoration(
                  labelText: 'Ağ Güvenlik Anahtarı (Token)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureToken ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                    onPressed: () => setState(() => _obscureToken = !_obscureToken),
                  ),
                  helperText: 'İstemcilerin bağlanırken doğrulayacağı gizli anahtar',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        ElevatedButton.icon(
          icon: const Icon(Icons.save_rounded),
          label: const Text('Sunucu Ayarlarını Kaydet'),
          onPressed: _saveServerSettings,
        ),
      ],
    );
  }

  Widget _buildClientView(ThemeData theme, LanNetworkState netState) {
    final status = netState.clientStatus;
    final isConnecting = status == LanConnectionStatus.connecting;

    Color statusColor;
    IconData statusIcon;
    String statusTitle;

    switch (status) {
      case LanConnectionStatus.connected:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        statusTitle = 'Merkez Sunucuya Bağlı (${netState.pingMs ?? 0} ms)';
        break;
      case LanConnectionStatus.connecting:
        statusColor = Colors.blue;
        statusIcon = Icons.sync_rounded;
        statusTitle = 'Sunucuya Bağlanılıyor...';
        break;
      case LanConnectionStatus.error:
      case LanConnectionStatus.disconnected:
        statusColor = Colors.red;
        statusIcon = Icons.error_outline_rounded;
        statusTitle = 'Bağlantı Hatası: ${netState.statusMessage ?? "Bağlanılamadı"}';
        break;
      case LanConnectionStatus.idle:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline_rounded;
        statusTitle = 'Bağlantı Durumu: Test Edilmedi';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Durum Bildirimi
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: statusColor, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    if (netState.config.lastSyncTime != null)
                      Text(
                        'Son Eşitleme: ${netState.config.lastSyncTime!.hour.toString().padLeft(2, '0')}:${netState.config.lastSyncTime!.minute.toString().padLeft(2, '0')}:${netState.config.lastSyncTime!.second.toString().padLeft(2, '0')}',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              FilledButton.icon(
                icon: netState.isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync_rounded, size: 18),
                label: Text(netState.isSyncing ? 'Eşitleniyor...' : 'Şimdi Eşitle'),
                onPressed: netState.isSyncing
                    ? null
                    : () async {
                        final ok = await ref.read(lanNetworkProvider.notifier).syncNow();
                        if (!mounted) return;
                        if (ok) {
                          PGYSFeedback.showSuccess(context, 'Merkez veritabanı ile eşitlendi.');
                        } else {
                          PGYSFeedback.showError(context, 'Eşitleme başarısız!');
                        }
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Bağlantı Parametreleri
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Merkez Sunucu IP Adresi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.dns_rounded),
                  hintText: 'Örn: 192.168.1.50',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers_rounded),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        TextFormField(
          controller: _tokenController,
          obscureText: _obscureToken,
          decoration: InputDecoration(
            labelText: 'Ağ Güvenlik Anahtarı (Token)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.key_rounded),
            suffixIcon: IconButton(
              icon: Icon(_obscureToken ? Icons.visibility_rounded : Icons.visibility_off_rounded),
              onPressed: () => setState(() => _obscureToken = !_obscureToken),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Otomatik Senkronizasyon Ayarı
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Arka Planda Otomatik Senkronizasyon'),
          subtitle: const Text('Merkez sunucudaki güncellemeleri periyodik olarak çeker'),
          value: _autoSync,
          onChanged: (val) => setState(() => _autoSync = val),
        ),
        const SizedBox(height: AppSpacing.md),

        // Eylemler
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              icon: isConnecting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.network_ping_rounded),
              label: const Text('Bağlantıyı Test Et'),
              onPressed: isConnecting
                  ? null
                  : () async {
                      final port = int.tryParse(_portController.text.trim()) ?? 8085;
                      final ok = await ref.read(lanNetworkProvider.notifier).testConnection(
                            host: _hostController.text.trim(),
                            port: port,
                            token: _tokenController.text.trim(),
                          );
                      if (!mounted) return;
                      if (ok) {
                        PGYSFeedback.showSuccess(
                          context,
                          'Merkez sunucuya başarıyla ulaşıldı!',
                        );
                      } else {
                        PGYSFeedback.showError(
                          context,
                          'Sunucuya bağlanılamadı. IP ve Port bilgilerini kontrol edin.',
                        );
                      }
                    },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_rounded),
              label: const Text('İstemci Ayarlarını Kaydet'),
              onPressed: _saveClientSettings,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveServerSettings() async {
    final port = int.tryParse(_portController.text.trim()) ?? 8085;
    final token = _tokenController.text.trim();

    final currentCfg = ref.read(lanNetworkProvider).config;
    final updated = currentCfg.copyWith(
      mode: NetworkMode.server,
      serverPort: port,
      authToken: token.isNotEmpty ? token : 'pgys-lan-secret',
    );

    await ref.read(lanNetworkProvider.notifier).updateConfig(updated);
    if (!mounted) return;
    PGYSFeedback.showSuccess(context, 'Sunucu yapılandırması kaydedildi.');
  }

  Future<void> _saveClientSettings() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8085;
    final token = _tokenController.text.trim();
    final interval = int.tryParse(_intervalController.text.trim()) ?? 15;

    final currentCfg = ref.read(lanNetworkProvider).config;
    final updated = currentCfg.copyWith(
      mode: NetworkMode.client,
      serverHost: host.isNotEmpty ? host : '127.0.0.1',
      serverPort: port,
      authToken: token.isNotEmpty ? token : 'pgys-lan-secret',
      autoSyncEnabled: _autoSync,
      syncIntervalSeconds: interval,
    );

    await ref.read(lanNetworkProvider.notifier).updateConfig(updated);
    if (!mounted) return;
    PGYSFeedback.showSuccess(context, 'İstemci yapılandırması kaydedildi.');
  }
}
