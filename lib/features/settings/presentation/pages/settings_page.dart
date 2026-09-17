import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import '../widgets/appearance_settings_section.dart';
import '../widgets/backup_settings_section.dart';
import '../widgets/general_settings_section.dart';
import '../widgets/lan_settings_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final personnelAsync = ref.watch(personnelListProvider);
    final leaveAsync = ref.watch(leaveControllerProvider);
    final taskAsync = ref.watch(taskControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Ayarlar',
            subtitle: 'Uygulama ve sistem ayarları',
          ),
          const SizedBox(height: 24),
          settingsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => PGYSCard(
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Ayarlar yüklenirken hata oluştu.\n$error'),
                  ),
                ],
              ),
            ),
            data: (settings) => _SettingsContent(
              settings: settings,
              onSave: (updated) => ref
                  .read(settingsProvider.notifier)
                  .updateSettings(updated),
              personnelCount: personnelAsync.when(
                data: (items) => items.length,
                loading: () => 0,
                error: (_, _) => 0,
              ),
              leaveCount: leaveAsync.when(
                data: (items) => items.length,
                loading: () => 0,
                error: (_, _) => 0,
              ),
              taskCount: taskAsync.when(
                data: (items) => items.length,
                loading: () => 0,
                error: (_, _) => 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  final AppSettings settings;
  final Future<void> Function(AppSettings) onSave;
  final int personnelCount;
  final int leaveCount;
  final int taskCount;

  const _SettingsContent({
    required this.settings,
    required this.onSave,
    required this.personnelCount,
    required this.leaveCount,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManageSettings =
        ref.watch(hasPermissionProvider(AppPermission.manageSettings));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsCard(
          title: 'Genel Ayarlar',
          icon: Icons.tune_outlined,
          child: GeneralSettingsSection(
            settings: settings,
            onSave: onSave,
            isReadOnly: !canManageSettings,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsCard(
          title: 'Görünüm',
          icon: Icons.palette_outlined,
          child: AppearanceSettingsSection(
            settings: settings,
            onSave: onSave,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsCard(
          title: 'Veri Durumu',
          icon: Icons.storage_outlined,
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _DataCount(label: 'Personel', value: personnelCount),
              _DataCount(label: 'Görev', value: taskCount),
              _DataCount(label: 'İzin / Rapor', value: leaveCount),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SettingsCard(
          title: 'Yerel Ağ (LAN) ve Çoklu Bilgisayar Yapılandırması',
          icon: Icons.lan_outlined,
          child: LanSettingsSection(),
        ),
        const SizedBox(height: 16),
        const _SettingsCard(
          title: 'Veritabanı Yedekleme & Geri Yükleme',
          icon: Icons.backup_outlined,
          child: BackupSettingsSection(),
        ),
        const SizedBox(height: 16),
        const _SettingsCard(
          title: 'Kullanım Bilgisi',
          icon: Icons.info_outline,
          child: Text(
            'Veriler bu cihazdaki yerel veritabanında tutulur. İzin belgesi '
            'oluştururken girilen adres, izin kaydıyla birlikte saklanır.',
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _DataCount extends StatelessWidget {
  final String label;
  final int value;

  const _DataCount({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
