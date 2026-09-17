import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/database_backup_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';

class BackupSettingsSection extends ConsumerStatefulWidget {
  const BackupSettingsSection({super.key});

  @override
  ConsumerState<BackupSettingsSection> createState() =>
      _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends ConsumerState<BackupSettingsSection> {
  bool _busy = false;

  DatabaseBackupService get _service {
    return DatabaseBackupService(getIt<AppDatabase>());
  }

  Future<void> _backup() async {
    setState(() => _busy = true);
    try {
      final path = await _service.exportBackup();
      if (!mounted || path == null) return;

      ref.read(settingsProvider.notifier).updateLastBackupDate(DateTime.now());
      ref.invalidate(availableBackupsProvider);

      PGYSFeedback.showSuccess(
        context,
        'Yedek başarıyla kaydedildi: ${p.basename(path)}',
      );
    } catch (error) {
      if (!mounted) return;
      PGYSFeedback.showError(
        context,
        'Yedek alınamadı: $error',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _triggerAutoBackup(AppSettings settings) async {
    setState(() => _busy = true);
    try {
      final result = await _service.performAutoBackupIfNeeded(
        settings: settings.copyWith(lastBackupDate: null), // Force run now
      );

      if (!mounted) return;

      if (result.success) {
        if (result.timestamp != null) {
          ref
              .read(settingsProvider.notifier)
              .updateLastBackupDate(result.timestamp!);
        }
        ref.invalidate(availableBackupsProvider);
        PGYSFeedback.showSuccess(
          context,
          'Otomatik yedek alındı. ${result.prunedCount > 0 ? "(${result.prunedCount} eski yedek temizlendi)" : ""}',
        );
      } else {
        PGYSFeedback.showWarning(context, result.message ?? 'İşlem tamamlanamadı.');
      }
    } catch (error) {
      if (!mounted) return;
      PGYSFeedback.showError(context, 'Hata: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeBackupDirectory(AppSettings settings) async {
    final picked = await _service.pickBackupDirectory();
    if (picked == null || !mounted) return;

    await ref.read(settingsProvider.notifier).updateSettings(
          settings.copyWith(backupDirectoryPath: picked),
        );
    ref.invalidate(availableBackupsProvider);
    if (!mounted) return;
    PGYSFeedback.showSuccess(context, 'Yedekleme dizini güncellendi: $picked');
  }

  Future<void> _restore({String? specificPath}) async {
    final path = specificPath ?? await _service.pickBackupFile();
    if (path == null) return;

    setState(() => _busy = true);

    final validation = await _service.validateBackupFile(path);
    if (mounted) {
      setState(() => _busy = false);
    }

    if (!validation.isValid) {
      if (!mounted) return;
      PGYSFeedback.showError(
        context,
        validation.errorMessage ?? 'Seçilen dosya geçerli bir PGYS yedeği değil.',
        title: 'Geçersiz Yedek Dosyası',
      );
      return;
    }

    final details = <String>[
      'Dosya: ${p.basename(path)}',
      if (validation.fileSizeBytes != null)
        'Boyut: ${(validation.fileSizeBytes! / 1024).toStringAsFixed(1)} KB',
      if (validation.personnelCount != null)
        'Personel Kaydı: ${validation.personnelCount}',
      if (validation.userCount != null)
        'Kullanıcı Hesabı: ${validation.userCount}',
      if (validation.taskCount != null)
        'Görev Kaydı: ${validation.taskCount}',
      if (validation.leaveCount != null)
        'İzin / Rapor Kaydı: ${validation.leaveCount}',
      'Mevcut verilerin üzerine bu yedeğin verileri yazılacaktır.',
      'İşlem öncesinde mevcut veritabanınızın güvenlik kopyası (pgys_pre_restore_safety_backup.sqlite) otomatik alınacaktır.',
      'Geri yükleme sonrasında verilerin aktif olması için uygulama kapanacaktır.',
    ];

    if (!mounted) return;

    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Yedekten Geri Yükle',
      message:
          'Seçilen yedek dosyasındaki verileri geri yüklemek istediğinize emin misiniz?',
      details: details,
      confirmText: 'Geri Yükle ve Kapat',
      cancelText: 'Vazgeç',
      isDestructive: true,
    );

    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _service.restoreBackup(path);
      if (!mounted) return;

      PGYSFeedback.showSuccess(
        context,
        'Veritabanı başarıyla geri yüklendi. Değişikliklerin etkili olması için uygulama kapatılıyor...',
        title: 'Geri Yükleme Tamamlandı',
        duration: const Duration(seconds: 3),
      );

      await Future.delayed(const Duration(seconds: 2));
      exit(0);
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      PGYSFeedback.showError(
        context,
        'Geri yükleme başarısız: $error',
      );
    }
  }

  Future<void> _rollbackSafetySnapshot() async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Güvenlik Kopyasına Geri Dön (Rollback)',
      message:
          'Son geri yükleme öncesinde otomatik oluşturulan güvenlik kopyasına geri dönmek istiyor musunuz?',
      details: const [
        'En son restore öncesindeki sağlam veritabanı kopyası yüklenecektir.',
        'İşlem sonrası uygulamanın yeniden başlatılması gerekmektedir.',
      ],
      confirmText: 'Güvenlik Kopyasına Dön ve Kapat',
      cancelText: 'Vazgeç',
      isDestructive: true,
    );

    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _service.rollbackSafetySnapshot();
      if (!mounted) return;

      PGYSFeedback.showSuccess(
        context,
        'Güvenlik kopyası başarıyla geri yüklendi. Uygulama kapatılıyor...',
        title: 'Rollback Tamamlandı',
        duration: const Duration(seconds: 3),
      );

      await Future.delayed(const Duration(seconds: 2));
      exit(0);
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      PGYSFeedback.showError(context, 'Rollback başarısız: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final canBackup =
        ref.watch(hasPermissionProvider(AppPermission.backupRestore));
    final settingsAsync = ref.watch(settingsProvider);
    final hasSafetySnapshotAsync = ref.watch(hasSafetySnapshotProvider);
    final availableBackupsAsync = ref.watch(availableBackupsProvider);
    final theme = Theme.of(context);

    if (!canBackup) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Veritabanı yedekleme ve geri yükleme işlemleri yalnızca Büro Amiri yetkisine açıktır.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Veriler bu bilgisayardaki yerel veritabanında tutulur. '
          'Düzenli yedek alın; bilgisayar değişiminde veya arızada geri yükleyebilirsiniz.',
          style: TextStyle(height: 1.4),
        ),
        const SizedBox(height: 16),

        // Manuel Aksiyon Butonları
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: _busy ? null : _backup,
              icon: const Icon(Icons.backup_outlined),
              label: const Text('Yedek Al'),
            ),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _restore(),
              icon: const Icon(Icons.restore_outlined),
              label: const Text('Yedekten Geri Yükle'),
            ),
            hasSafetySnapshotAsync.maybeWhen(
              data: (hasSnapshot) => hasSnapshot
                  ? OutlinedButton.icon(
                      onPressed: _busy ? null : _rollbackSafetySnapshot,
                      icon: const Icon(Icons.history_rounded),
                      label: const Text('Güvenlik Kopyasına Dön (Rollback)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
            if (_busy) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const Text(
                'İşlem yapılıyor...',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),

        const Divider(height: 32),

        // Otomatik Yedekleme Yönetimi
        settingsAsync.maybeWhen(
          data: (settings) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Otomatik Yedekleme & Rotasyon',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: settings.autoBackupEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).updateSettings(
                            settings.copyWith(autoBackupEnabled: val),
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (settings.autoBackupEnabled) ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: settings.autoBackupIntervalHours,
                        decoration: const InputDecoration(
                          labelText: 'Yedekleme Sıklığı',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 12, child: Text('12 Saatte Bir')),
                          DropdownMenuItem(value: 24, child: Text('24 Saatte Bir (Günlük)')),
                          DropdownMenuItem(value: 168, child: Text('Haftalık (7 Gün)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(settingsProvider.notifier).updateSettings(
                                  settings.copyWith(autoBackupIntervalHours: val),
                                );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: settings.maxBackupRetentionCount,
                        decoration: const InputDecoration(
                          labelText: 'Saklama Limiti (Rotasyon)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 5, child: Text('Son 5 Yedek')),
                          DropdownMenuItem(value: 10, child: Text('Son 10 Yedek')),
                          DropdownMenuItem(value: 20, child: Text('Son 20 Yedek')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(settingsProvider.notifier).updateSettings(
                                  settings.copyWith(maxBackupRetentionCount: val),
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Klasör: ${settings.backupDirectoryPath ?? "Varsayılan (Belgeler/PGYS/backups)"}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _changeBackupDirectory(settings),
                      icon: const Icon(Icons.folder_open, size: 16),
                      label: const Text('Klasör Seç'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonalIcon(
                      onPressed: _busy ? null : () => _triggerAutoBackup(settings),
                      icon: const Icon(Icons.play_arrow_rounded, size: 16),
                      label: const Text('Şimdi Otomatik Yedekle'),
                    ),
                  ],
                ),
                if (settings.lastBackupDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Son Yedekleme: ${DateFormat("dd.MM.yyyy HH:mm").format(settings.lastBackupDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          orElse: () => const SizedBox.shrink(),
        ),

        const SizedBox(height: 16),

        // Mevcut Yedek Dosyaları Listesi
        availableBackupsAsync.maybeWhen(
          data: (backups) {
            if (backups.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kayıtlı Yedek Dosyaları (${backups.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: backups.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = backups[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.storage_rounded, size: 20),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${item.formattedSize} • ${DateFormat("dd.MM.yyyy HH:mm").format(item.modifiedDate)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: OutlinedButton(
                          onPressed: _busy ? null : () => _restore(specificPath: item.path),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('Geri Yükle', style: TextStyle(fontSize: 11)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

