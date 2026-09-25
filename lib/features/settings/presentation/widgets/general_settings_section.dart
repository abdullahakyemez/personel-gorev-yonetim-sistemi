import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import '../../domain/models/app_settings.dart';

class GeneralSettingsSection extends StatefulWidget {
  final AppSettings settings;
  final Future<void> Function(AppSettings) onSave;
  final bool isReadOnly;

  const GeneralSettingsSection({
    super.key,
    required this.settings,
    required this.onSave,
    this.isReadOnly = false,
  });

  @override
  State<GeneralSettingsSection> createState() => _GeneralSettingsSectionState();
}

class _GeneralSettingsSectionState extends State<GeneralSettingsSection> {
  late final TextEditingController _appNameController;
  late final TextEditingController _institutionTitleController;
  late final TextEditingController _agencyCityController;
  late final TextEditingController _defaultAmirNameController;
  late final TextEditingController _defaultAmirRankController;
  late final TextEditingController _defaultAmirTitleController;
  late String _selectedDateFormat;
  bool _saving = false;

  static const _dateFormats = ['dd.MM.yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: widget.settings.appName);
    _institutionTitleController =
        TextEditingController(text: widget.settings.institutionTitle);
    _agencyCityController =
        TextEditingController(text: widget.settings.agencyCity);
    _defaultAmirNameController =
        TextEditingController(text: widget.settings.defaultAmirName);
    _defaultAmirRankController =
        TextEditingController(text: widget.settings.defaultAmirRank);
    _defaultAmirTitleController =
        TextEditingController(text: widget.settings.defaultAmirTitle);
    _selectedDateFormat = _dateFormats.contains(widget.settings.dateFormat)
        ? widget.settings.dateFormat
        : _dateFormats.first;
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _institutionTitleController.dispose();
    _agencyCityController.dispose();
    _defaultAmirNameController.dispose();
    _defaultAmirRankController.dispose();
    _defaultAmirTitleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final appName = _appNameController.text.trim();
    if (appName.isEmpty) {
      PGYSFeedback.showWarning(context, 'Uygulama adı boş bırakılamaz.');
      return;
    }

    final institutionTitle = _institutionTitleController.text.trim();
    final agencyCity = _agencyCityController.text.trim();
    final defaultAmirName = _defaultAmirNameController.text.trim();
    final defaultAmirRank = _defaultAmirRankController.text.trim();
    final defaultAmirTitle = _defaultAmirTitleController.text.trim();

    setState(() => _saving = true);
    try {
      await widget.onSave(
        widget.settings.copyWith(
          appName: appName,
          institutionTitle: institutionTitle.isNotEmpty
              ? institutionTitle
              : widget.settings.institutionTitle,
          agencyCity:
              agencyCity.isNotEmpty ? agencyCity : widget.settings.agencyCity,
          dateFormat: _selectedDateFormat,
          defaultAmirName: defaultAmirName.isNotEmpty
              ? defaultAmirName
              : widget.settings.defaultAmirName,
          defaultAmirRank: defaultAmirRank.isNotEmpty
              ? defaultAmirRank
              : widget.settings.defaultAmirRank,
          defaultAmirTitle: defaultAmirTitle.isNotEmpty
              ? defaultAmirTitle
              : widget.settings.defaultAmirTitle,
        ),
      );
      if (!mounted) return;
      PGYSFeedback.showSuccess(context, 'Genel ayarlar kaydedildi.');
    } catch (_) {
      if (!mounted) return;
      PGYSFeedback.showError(context, 'Genel ayarlar kaydedilemedi.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = widget.isReadOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _institutionTitleController,
          enabled: !readOnly,
          decoration: const InputDecoration(
            labelText: 'Kurum / Birim Başlığı',
            hintText: 'Örn: T.C. İÇİŞLERİ BAKANLIĞI EMNİYET GENEL MÜDÜRLÜĞÜ',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _appNameController,
                enabled: !readOnly,
                decoration: const InputDecoration(
                  labelText: 'Uygulama Adı',
                  hintText: 'Uygulama adını giriniz',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _agencyCityController,
                enabled: !readOnly,
                decoration: const InputDecoration(
                  labelText: 'İl / Birim Bölgesi',
                  hintText: 'Örn: ANKARA',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _selectedDateFormat,
          decoration: const InputDecoration(
            labelText: 'Tarih Formatı',
            border: OutlineInputBorder(),
          ),
          items: _dateFormats
              .map((format) => DropdownMenuItem(
                    value: format,
                    child: Text(format),
                  ))
              .toList(),
          onChanged: (readOnly || _saving)
              ? null
              : (value) {
                  if (value != null) {
                    setState(() => _selectedDateFormat = value);
                  }
                },
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Resmi Evrak & İzin Belgesi Büro Amiri Bilgileri',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _defaultAmirNameController,
                enabled: !readOnly,
                decoration: const InputDecoration(
                  labelText: 'Büro Amiri Adı Soyadı',
                  hintText: 'Örn: Abdullah HAKYEMEZ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _defaultAmirRankController,
                enabled: !readOnly,
                decoration: const InputDecoration(
                  labelText: 'Amir Rütbesi',
                  hintText: 'Örn: Başkomiser',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _defaultAmirTitleController,
          enabled: !readOnly,
          decoration: const InputDecoration(
            labelText: 'Amir Görev Unvanı (Varsayılan)',
            hintText: 'Örn: Büro Amiri',
            border: OutlineInputBorder(),
          ),
        ),
        if (!readOnly) ...[
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Kaydediliyor...' : 'Kaydet'),
            ),
          ),
        ],
      ],
    );
  }
}
