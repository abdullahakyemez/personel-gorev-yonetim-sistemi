import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_document_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';

/// İzin dilekçesi (Word / DOCX) belgesi oluşturulurken
/// Büro Amiri veya Vekil (Büro Amir V.) onay makamının seçilmesini sağlayan diyalog.
class LeaveDocumentExportDialog extends ConsumerStatefulWidget {
  final Leave leave;
  final Personnel person;

  const LeaveDocumentExportDialog({
    super.key,
    required this.leave,
    required this.person,
  });

  static Future<String?> show(
    BuildContext context, {
    required Leave leave,
    required Personnel person,
  }) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LeaveDocumentExportDialog(leave: leave, person: person),
    );
  }

  @override
  ConsumerState<LeaveDocumentExportDialog> createState() =>
      _LeaveDocumentExportDialogState();
}

class _LeaveDocumentExportDialogState
    extends ConsumerState<LeaveDocumentExportDialog> {
  bool _isActing = false; // false: Büro Amiri (Asil), true: Büro Amir V. (Vekil)
  bool _isCustomTitle = false;
  bool _isExporting = false;

  late final TextEditingController _nameController;
  late final TextEditingController _rankController;
  late final TextEditingController _titleController;

  Personnel? _selectedDeputy;

  @override
  void initState() {
    super.initState();
    final defaultTitle =
        formatAmirTitle(widget.person.branch, isActing: false);
    _titleController = TextEditingController(text: defaultTitle);
    _nameController = TextEditingController();
    _rankController = TextEditingController();

    // Ayarlardaki varsayılan amir bilgilerini yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider).value;
      if (settings != null) {
        _nameController.text = settings.defaultAmirName;
        _rankController.text = settings.defaultAmirRank;
        if (!_isCustomTitle) {
          _updateDefaultTitle();
        }
        setState(() {});
      } else {
        _nameController.text = '';
        _rankController.text = 'Büro Amiri';
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  static String formatAmirTitle(String branch, {required bool isActing}) {
    final branchTrimmed = branch.trim();
    if (branchTrimmed.endsWith('Büro Amirliği')) {
      final base = branchTrimmed
          .substring(0, branchTrimmed.length - 'Büro Amirliği'.length)
          .trim();
      return isActing ? '$base Büro Amir V.' : '$base Büro Amiri';
    }
    return isActing ? '$branchTrimmed Büro Amir V.' : '$branchTrimmed Büro Amiri';
  }

  void _updateDefaultTitle() {
    _titleController.text =
        formatAmirTitle(widget.person.branch, isActing: _isActing);
  }

  void _onActingChanged(bool acting) {
    setState(() {
      _isActing = acting;
      if (!_isCustomTitle) {
        _updateDefaultTitle();
      }
    });
  }

  void _onDeputySelected(Personnel? person) {
    setState(() {
      _selectedDeputy = person;
      if (person != null) {
        _nameController.text = person.fullName;
        _rankController.text = person.rank;
      }
    });
  }

  void _resetToDefaultAmir() {
    final settings = ref.read(settingsProvider).value;
    setState(() {
      _selectedDeputy = null;
      _isActing = false;
      _nameController.text = settings?.defaultAmirName ?? '';
      _rankController.text = settings?.defaultAmirRank ?? 'Büro Amiri';
      _isCustomTitle = false;
      _updateDefaultTitle();
    });
  }

  Future<void> _export() async {
    final name = _nameController.text.trim();
    final rank = _rankController.text.trim();
    final title = _titleController.text.trim();

    if (name.isEmpty) {
      PGYSFeedback.showWarning(context, 'İmzalayacak yetkili adı boş bırakılamaz.');
      return;
    }

    setState(() => _isExporting = true);
    try {
      final savedPath = await LeaveDocumentService().exportLeaveDocument(
        leave: widget.leave,
        person: widget.person,
        amirName: name,
        amirRank: rank.isNotEmpty ? rank : 'Başkomiser',
        amirTitle: title.isNotEmpty ? title : null,
        isActing: _isActing,
      );

      if (!mounted) return;
      if (savedPath != null) {
        Navigator.of(context).pop(savedPath);
        PGYSFeedback.showSuccess(
          context,
          'İzin dilekçesi (${_isActing ? "Büro Amir V." : "Büro Amiri"}) kaydedildi.',
        );
      } else {
        setState(() => _isExporting = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isExporting = false);
      PGYSFeedback.showError(context, 'Belge oluşturulurken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppSettings>>(settingsProvider, (prev, next) {
      final settings = next.value;
      if (settings != null && _selectedDeputy == null) {
        if (_nameController.text.isEmpty && settings.defaultAmirName.isNotEmpty) {
          _nameController.text = settings.defaultAmirName;
        }
        if (_rankController.text.isEmpty || _rankController.text == 'Büro Amiri') {
          if (settings.defaultAmirRank.isNotEmpty) {
            _rankController.text = settings.defaultAmirRank;
          }
        }
        if (!_isCustomTitle) {
          _updateDefaultTitle();
        }
        if (mounted) setState(() {});
      }
    });

    final theme = Theme.of(context);
    final personnelList = ref.watch(personnelListProvider).value ?? [];
    // İznini isteyen personelin kendisini vekil listesinden hariç tutalım
    final eligibleDeputies =
        personnelList.where((p) => p.id != widget.person.id).toList();

    final todayFormatted =
        '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık ve İkon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İzin Belgesi Oluştur (Word)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.person.fullName} (${widget.person.registryNumber}) - ${widget.leave.dayCount} Gün',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),

              // Yetkili Makam Türü Seçimi (Asil / Vekil)
              Text(
                'Onay Makamı (Görüldü İmzası):',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Büro Amiri (Asil)'),
                    icon: Icon(Icons.verified_user_outlined),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Büro Amir Vekili (Vekil)'),
                    icon: Icon(Icons.assignment_ind_outlined),
                  ),
                ],
                selected: {_isActing},
                onSelectionChanged: _isExporting
                    ? null
                    : (selection) => _onActingChanged(selection.first),
              ),
              const SizedBox(height: AppSpacing.md),

              // Personel Listesinden Vekil / Yetkili Seçimi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isActing
                          ? 'Vekalet Eden Personel Seçimi:'
                          : 'İmzalayacak Amir:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isActing || _selectedDeputy != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: _isExporting ? null : _resetToDefaultAmir,
                      icon: const Icon(Icons.restore, size: 16),
                      label: const Text('Varsayılan Amir',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Personel Seçim Dropdown'ı
              DropdownButtonFormField<Personnel?>(
                isExpanded: true,
                initialValue: _selectedDeputy,
                decoration: InputDecoration(
                  hintText: _isActing
                      ? 'Yerine bakacak personeli listeden seçiniz...'
                      : 'Kadro içerisinden seçiniz (isteğe bağlı)...',
                  prefixIcon: const Icon(Icons.person_search_outlined),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                ),
                items: [
                  const DropdownMenuItem<Personnel?>(
                    value: null,
                    child: Text('Manuel / Varsayılan Bilgileri Kullan'),
                  ),
                  ...eligibleDeputies.map(
                    (p) => DropdownMenuItem<Personnel?>(
                      value: p,
                      child: Text('${p.fullName} (${p.rank}) - ${p.branch}'),
                    ),
                  ),
                ],
                onChanged: _isExporting ? null : _onDeputySelected,
              ),
              const SizedBox(height: AppSpacing.md),

              // İmza Bilgileri (Ad Soyad ve Rütbe)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _nameController,
                      enabled: !_isExporting,
                      decoration: const InputDecoration(
                        labelText: 'Yetkili Adı Soyadı',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _rankController,
                      enabled: !_isExporting,
                      decoration: const InputDecoration(
                        labelText: 'Rütbesi',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Görev Unvanı Alanı
              TextFormField(
                controller: _titleController,
                enabled: !_isExporting,
                decoration: InputDecoration(
                  labelText: 'Görev Unvanı (Belgede Çıkacak Şekliyle)',
                  helperText: _isActing
                      ? 'Örn: ${widget.person.branch} Büro Amir V.'
                      : 'Örn: ${widget.person.branch} Büro Amiri',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  _isCustomTitle = true;
                  setState(() {});
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Canlı Görüldü Önizleme Kartı
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BELGE İMZA BLOĞU ÖNİZLEMESİ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isActing
                                ? Colors.amber.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _isActing ? 'VEKALETEN İMZA' : 'ASİLEN İMZA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _isActing
                                  ? Colors.amber.shade900
                                  : Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      'GÖRÜLDÜ',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      todayFormatted,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _nameController.text.trim().isNotEmpty
                          ? _nameController.text.trim()
                          : '[İmza Yetkilisi]',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _titleController.text.trim().isNotEmpty
                          ? _titleController.text.trim()
                          : (_isActing
                              ? '${widget.person.branch} Büro Amir V.'
                              : '${widget.person.branch} Büro Amiri'),
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _rankController.text.trim().isNotEmpty
                          ? _rankController.text.trim()
                          : '[Rütbe]',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Alt Butonlar
              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  OutlinedButton(
                    onPressed:
                        _isExporting ? null : () => Navigator.of(context).pop(),
                    child: const Text('İptal'),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2A5298),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onPressed: _isExporting ? null : _export,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(_isExporting
                        ? 'Oluşturuluyor...'
                        : 'Dilekçeyi Oluştur (.docx)'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
