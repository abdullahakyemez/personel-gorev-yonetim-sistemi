import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_import_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

Future<void> showPersonnelImportDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => const PersonnelImportDialog(),
  );
}

class PersonnelImportDialog extends ConsumerStatefulWidget {
  const PersonnelImportDialog({super.key});

  @override
  ConsumerState<PersonnelImportDialog> createState() =>
      _PersonnelImportDialogState();
}

class _PersonnelImportDialogState extends ConsumerState<PersonnelImportDialog> {
  final _importService = PersonnelExcelImportService();

  String? _selectedFileName;
  PersonnelImportAnalysis? _analysis;
  bool _isAnalyzing = false;
  bool _isImporting = false;
  bool _overwriteExisting = true;

  Future<void> _downloadTemplate() async {
    try {
      final path = await _importService.exportTemplateAndSave();
      if (!mounted || path == null) return;
      PGYSFeedback.showSuccess(
        context,
        'Örnek personel şablonu kaydedildi: $path',
      );
    } catch (e) {
      if (!mounted) return;
      PGYSFeedback.showError(context, 'Şablon indirilemedi: $e');
    }
  }

  Future<void> _pickAndAnalyzeFile() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Excel Dosyaları',
        extensions: ['xlsx', 'xls'],
      );

      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      setState(() {
        _isAnalyzing = true;
        _selectedFileName = file.name;
        _analysis = null;
      });

      final bytes = await file.readAsBytes();

      // Mevcut sicil numaralarını veritabanından alalım
      final existingPersonnel = await ref.read(personnelListProvider.future);
      final existingRegistryNumbers =
          existingPersonnel.map((p) => p.registryNumber).toSet();

      final analysis = _importService.parseExcelBytes(
        bytes: bytes,
        existingRegistryNumbers: existingRegistryNumbers,
      );

      if (!mounted) return;
      setState(() {
        _analysis = analysis;
        _isAnalyzing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _analysis = null;
      });
      PGYSFeedback.showError(context, 'Excel dosyası okunamadı: $e');
    }
  }

  Future<void> _executeImport() async {
    final analysis = _analysis;
    if (analysis == null || analysis.validRows.isEmpty) return;

    final targetRows = _overwriteExisting
        ? analysis.validRows
        : analysis.newValidRows;

    if (targetRows.isEmpty) {
      PGYSFeedback.showWarning(
        context,
        'Aktarılacak geçerli yeni personel bulunmuyor.',
      );
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      final personnelToImport =
          targetRows.map((r) => r.personnel!).toList();

      final useCase = ref.read(importPersonnelUseCaseProvider);
      final result = await useCase(
        personnelList: personnelToImport,
        overwriteExisting: _overwriteExisting,
      );

      if (!mounted) return;

      ref.invalidate(personnelListProvider);

      Navigator.of(context).pop();

      final msg = StringBuffer('Toplu içe aktarma tamamlandı: ')
        ..write('${result.insertedCount} yeni personel eklendi.');
      if (result.updatedCount > 0) {
        msg.write(' ${result.updatedCount} personel güncellendi.');
      }
      if (result.skippedCount > 0) {
        msg.write(' ${result.skippedCount} mevcut kayıt atlandı.');
      }

      PGYSFeedback.showSuccess(context, msg.toString());
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isImporting = false;
      });
      PGYSFeedback.showError(context, 'İçe aktarma sırasında hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysis = _analysis;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PGYSDialog(
      title: 'Toplu Personel İçe Aktar',
      subtitle: 'Excel (.xlsx) dosyasından personelleri sisteme yükleyiniz',
      icon: Icons.upload_file_rounded,
      scrollable: true,
      actions: [
        TextButton(
          onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.excelGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          onPressed:
              (_isImporting || _isAnalyzing || analysis == null || analysis.validRows.isEmpty)
                  ? null
                  : _executeImport,
          icon: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline, size: 18),
          label: Text(
            _isImporting
                ? 'Aktarılıyor...'
                : analysis != null
                    ? 'İçe Aktar (${_overwriteExisting ? analysis.validRows.length : analysis.newValidRows.length} Kişi)'
                    : 'İçe Aktar',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Bilgilendirme ve Şablon İndirme Kartı
          PGYSCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.excelGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.table_chart_outlined,
                    color: AppColors.excelGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doğru Format İçin Örnek Şablon',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Excel tablonuzun sütun başlıklarının uyumlu olması için şablonu indirebilirsiniz.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.excelGreen,
                    side: const BorderSide(color: AppColors.excelGreen),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onPressed: _downloadTemplate,
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Şablonu İndir'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Dosya Seçme Alanı
          InkWell(
            onTap: _isAnalyzing || _isImporting ? null : _pickAndAnalyzeFile,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(14),
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
              ),
              child: Column(
                children: [
                  if (_isAnalyzing) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Excel dosyası inceleniyor ve doğrulanıyor...'),
                  ] else ...[
                    Icon(
                      _selectedFileName == null
                          ? Icons.file_upload_outlined
                          : Icons.description_outlined,
                      size: 38,
                      color: _selectedFileName == null
                          ? colorScheme.primary
                          : AppColors.excelGreen,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _selectedFileName ?? 'Bilgisayarınızdan Excel Dosyası Seçiniz (.xlsx)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _selectedFileName != null
                            ? colorScheme.onSurface
                            : colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedFileName == null
                          ? 'Tıklayarak veya dosya seçiciyle dosyanızı yükleyin'
                          : 'Başka bir dosya seçmek için tekrar tıklayabilirsiniz',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 3. Analiz ve Önizleme Kartları
          if (analysis != null) ...[
            const SizedBox(height: AppSpacing.md),

            // İstatistik sayaçları
            Row(
              children: [
                _buildStatChip(
                  context,
                  label: 'Toplam Satır',
                  count: analysis.totalRows,
                  icon: Icons.list_alt_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip(
                  context,
                  label: 'Yeni Personel',
                  count: analysis.newValidRows.length,
                  icon: Icons.person_add_rounded,
                  color: const Color(0xFF00875A),
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip(
                  context,
                  label: 'Mevcut (Mükerrer)',
                  count: analysis.duplicateRows.length,
                  icon: Icons.sync_rounded,
                  color: const Color(0xFFD97706),
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip(
                  context,
                  label: 'Hatalı Satır',
                  count: analysis.invalidRows.length,
                  icon: Icons.error_outline_rounded,
                  color: const Color(0xFFDC2626),
                ),
              ],
            ),

            // Mükerrer / Mevcut Sicil Davranışı Seçimi
            if (analysis.duplicateRows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              PGYSCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _overwriteExisting,
                  activeThumbColor: AppColors.excelGreen,
                  activeTrackColor: AppColors.excelGreen.withValues(alpha: 0.5),
                  title: const Text(


                    'Sistemde zaten kayıtlı personelleri güncelle',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _overwriteExisting
                        ? 'Excel\'deki mevcut sicillerin unvan, telefon, görev vb. bilgileri güncellenecek.'
                        : 'Sistemde zaten kayıtlı olan ${analysis.duplicateRows.length} personel atlanacak.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _overwriteExisting = val;
                    });
                  },
                ),
              ),
            ],

            // Hatalı Satırlar Listesi
            if (analysis.invalidRows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFDC2626),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${analysis.invalidRows.length} satırda doğrulama hatası tespit edildi (Bu satırlar aktarılmayacaktır):',
                          style: const TextStyle(
                            color: Color(0xFF991B1B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...analysis.invalidRows.take(5).map((row) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '• Satır ${row.rowNumber}: ${row.errors.join(", ")}',
                          style: const TextStyle(
                            color: Color(0xFFB91C1C),
                            fontSize: 12,
                          ),
                        ),
                      );
                    }),
                    if (analysis.invalidRows.length > 5) ...[
                      const SizedBox(height: 4),
                      Text(
                        've diğer ${analysis.invalidRows.length - 5} satır...',
                        style: const TextStyle(
                          color: Color(0xFFB91C1C),
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Geçerli Kayıtlar Önizleme Listesi
            if (analysis.validRows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Aktarılacak Personellerden Örnekler (İlk ${analysis.validRows.length > 5 ? 5 : analysis.validRows.length} Kayıt):',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: analysis.validRows.take(5).map((row) {
                    final p = row.personnel!;
                    final isDup = row.isDuplicate;

                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          p.fullName.isNotEmpty ? p.fullName[0] : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            p.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          if (isDup)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Mevcut',
                                style: TextStyle(
                                  color: Color(0xFFB45309),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        'Sicil: ${p.registryNumber} | ${p.rank} - ${p.branch}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 5),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
