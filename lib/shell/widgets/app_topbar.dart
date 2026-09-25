import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/branding/pgys_logo.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_about_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/providers/sidebar_provider.dart';
import '../../core/network/application/lan_network_provider.dart';
import '../../core/network/models/network_config.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/settings/application/settings_provider.dart';

class AppTopbar extends ConsumerWidget {
  const AppTopbar({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Oturumu Kapat',
      message:
          'Mevcut oturumunuz sonlandırılacak ve giriş ekranına yönlendirileceksiniz. Devam etmek istiyor musunuz?',
      confirmText: 'Çıkış Yap',
      cancelText: 'Vazgeç',
      isDestructive: false,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) {
        PGYSFeedback.showSuccess(context, 'Oturum başarıyla kapatıldı.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final netState = ref.watch(lanNetworkProvider);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final showDateBadge = constraints.maxWidth >= 1150;
        final showRoleBadge = constraints.maxWidth >= 980;
        final isCompactProfile = constraints.maxWidth < 860;

        return Container(
          height: AppSizes.topbarHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                width: .5,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.sm : AppSpacing.lg,
          ),
          child: Row(
            children: [
              Builder(
                builder: (ctx) {
                  final scaffold = Scaffold.maybeOf(ctx);
                  final hasDrawer = scaffold?.hasDrawer ?? false;

                  return IconButton(
                    tooltip: hasDrawer
                        ? 'Menüyü Aç'
                        : (isExpanded ? 'Menüyü Daralt' : 'Menüyü Genişlet'),
                    onPressed: () {
                      if (hasDrawer) {
                        scaffold?.openDrawer();
                      } else {
                        ref.read(sidebarExpandedProvider.notifier).state =
                            !isExpanded;
                      }
                    },
                    icon: const Icon(Icons.menu),
                  );
                },
              ),
              if (isMobile) ...[
                const SizedBox(width: AppSpacing.xs),
                const PGYSLogo(
                  variant: PGYSLogoVariant.horizontal,
                  size: 26,
                ),
              ] else ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.domain_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Asayiş Şube Müdürlüğü',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '/',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        Text(
                          ref.watch(settingsProvider).value?.appName.isNotEmpty == true
                              ? ref.watch(settingsProvider).value!.appName
                              : 'Hırsızlık Büro Amirliği',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (netState.config.mode != NetworkMode.standalone) ...[
                _LanStatusBadge(
                  netState: netState,
                  isCompact: isMobile,
                ),
                SizedBox(width: isMobile ? AppSpacing.xs : AppSpacing.md),
              ],
              if (currentUser != null) ...[
                if (!isCompactProfile) ...[
                  if (showDateBadge) ...[
                    // Güncel Tarih Rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            DateFormatter.longDateWithDay(DateTime.now()),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],

                  if (showRoleBadge) ...[
                    // Rol Rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE8E8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        currentUser.role.label,
                        style: const TextStyle(
                          color: Color(0xFF9B1C1C),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],

                  // Kullanıcı Adı ve Sicil
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentUser.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Sicil: ${currentUser.username}${currentUser.groupName != null && currentUser.groupName!.isNotEmpty ? ' • ${currentUser.groupName}' : ''}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    tooltip: 'Sistem Bilgisi & Hakkında',
                    icon: Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => showPGYSAboutDialog(context),
                  ),
                ] else ...[
                  // Mobil Kompakt Profil Menüsü (PopupMenuButton - Sıfır Taşma)
                  PopupMenuButton<String>(
                    tooltip: 'Hesap & Menü',
                    offset: const Offset(0, 48),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      child: Text(
                        currentUser.fullName.isNotEmpty
                            ? currentUser.fullName.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onSelected: (value) async {
                      if (value == 'about') {
                        showPGYSAboutDialog(context);
                      } else if (value == 'logout') {
                        await _handleLogout(context, ref);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.fullName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${currentUser.role.label} • Sicil: ${currentUser.username}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'about',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 20),
                            SizedBox(width: 10),
                            Text('Sistem Bilgisi & Hakkında'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 20,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Güvenli Çıkış Yap',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ] else ...[
                const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person, size: 18),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LanStatusBadge extends StatelessWidget {
  final LanNetworkState netState;
  final bool isCompact;

  const _LanStatusBadge({
    required this.netState,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isServer = netState.config.mode == NetworkMode.server;

    Color badgeColor;
    IconData badgeIcon;
    String badgeText;
    String tooltipText;

    if (isServer) {
      final isRunning = netState.isServerRunning;
      badgeColor = isRunning ? Colors.green : Colors.orange;
      badgeIcon = isRunning
          ? Icons.wifi_tethering_rounded
          : Icons.portable_wifi_off_rounded;
      badgeText = isRunning
          ? 'Sunucu :${netState.config.serverPort}'
          : 'Sunucu Kapalı';
      tooltipText = isRunning
          ? 'PGYS Yerel Ağ Sunucusu Yayında\nIP: ${netState.serverLocalIps.join(", ")}'
          : 'Sunucu durduruldu';
    } else {
      final status = netState.clientStatus;
      switch (status) {
        case LanConnectionStatus.connected:
          badgeColor = Colors.green;
          badgeIcon = Icons.lan_rounded;
          badgeText = 'Merkeze Bağlı (${netState.pingMs ?? 0}ms)';
          tooltipText =
              'Sunucu: ${netState.config.serverHost}:${netState.config.serverPort}';
          break;
        case LanConnectionStatus.connecting:
          badgeColor = Colors.blue;
          badgeIcon = Icons.sync_rounded;
          badgeText = 'Bağlanılıyor...';
          tooltipText = 'Sunucuya bağlanılıyor...';
          break;
        case LanConnectionStatus.error:
        case LanConnectionStatus.disconnected:
          badgeColor = Colors.red;
          badgeIcon = Icons.lan_outlined;
          badgeText = 'Bağlantı Yok';
          tooltipText =
              netState.statusMessage ?? 'Merkez sunucuya ulaşılamıyor';
          break;
        case LanConnectionStatus.idle:
          badgeColor = Colors.grey;
          badgeIcon = Icons.lan_outlined;
          badgeText = 'İstemci Modu';
          tooltipText = 'Bağlantı test edilmedi';
          break;
      }
    }

    if (isCompact) {
      return Tooltip(
        message: tooltipText,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
          ),
          child: Icon(badgeIcon, size: 16, color: badgeColor),
        ),
      );
    }

    return Tooltip(
      message: tooltipText,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(badgeIcon, size: 14, color: badgeColor),
            const SizedBox(width: 5),
            Text(
              badgeText,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

