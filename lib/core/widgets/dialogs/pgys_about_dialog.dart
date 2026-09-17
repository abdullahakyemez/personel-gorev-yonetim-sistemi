import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/application/lan_network_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/network/models/network_config.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/branding/pgys_logo.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';

class PGYSAboutDialog extends ConsumerWidget {
  const PGYSAboutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    final netState = ref.watch(lanNetworkProvider);

    final institutionTitle = settings != null && settings.institutionTitle.isNotEmpty
        ? settings.institutionTitle
        : 'T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 12,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo ve Başlık
              const PGYSLogo(
                variant: PGYSLogoVariant.stacked,
                size: 72,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'v1.0.0 • Kurumsal Sürüm',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                institutionTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Sistem Parametreleri & Kartlar
              _InfoRow(
                icon: Icons.storage_rounded,
                label: 'Veritabanı',
                value: 'Drift SQLite (ACID / Eşlenik Senkronizasyon)',
              ),
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.lan_outlined,
                label: 'Ağ Modu',
                value: netState.config.mode == NetworkMode.standalone
                    ? 'Bağımsız (Tek Bilgisayar)'
                    : (netState.config.mode == NetworkMode.server
                        ? 'Ana Sunucu (Port: ${netState.config.serverPort})'
                        : 'İstemci (${netState.config.serverHost}:${netState.config.serverPort})'),
              ),
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.security_rounded,
                label: 'Yetkilendirme',
                value: 'PBKDF2-HMAC-SHA256 • 6 Kademeli RBAC',
              ),
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.laptop_windows_rounded,
                label: 'Platform',
                value: 'Windows x64 Masaüstü & Hibrit Mobil Uyumlu',
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kapat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showPGYSAboutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const PGYSAboutDialog(),
  );
}
