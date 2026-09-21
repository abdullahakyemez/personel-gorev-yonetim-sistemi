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
    _selectedDateFormat = _dateFormats.contains(widget.settings.dateFormat)
        ? widget.settings.dateFormat
        : _dateFormats.first;
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _institutionTitleController.dispose();
    _agencyCityController.dispose();
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
