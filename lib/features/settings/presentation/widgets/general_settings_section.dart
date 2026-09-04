import 'package:flutter/material.dart';
import '../../domain/models/app_settings.dart';

class GeneralSettingsSection extends StatefulWidget {
  final AppSettings settings;
  final Future<void> Function(AppSettings) onSave;

  const GeneralSettingsSection({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<GeneralSettingsSection> createState() => _GeneralSettingsSectionState();
}

class _GeneralSettingsSectionState extends State<GeneralSettingsSection> {
  late final TextEditingController _appNameController;
  late String _selectedDateFormat;
  bool _saving = false;

  static const _dateFormats = ['dd.MM.yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: widget.settings.appName);
    _selectedDateFormat = _dateFormats.contains(widget.settings.dateFormat)
        ? widget.settings.dateFormat
        : _dateFormats.first;
  }

  @override
  void dispose() {
    _appNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final appName = _appNameController.text.trim();
    if (appName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uygulama adı boş bırakılamaz.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave(
        widget.settings.copyWith(
          appName: appName,
          dateFormat: _selectedDateFormat,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Genel ayarlar kaydedildi.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Genel ayarlar kaydedilemedi.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _appNameController,
          decoration: const InputDecoration(
            labelText: 'Uygulama Adı',
            hintText: 'Uygulama adını giriniz',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
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
          onChanged: _saving
              ? null
              : (value) {
                  if (value != null) {
                    setState(() => _selectedDateFormat = value);
                  }
                },
        ),
        const SizedBox(height: 16),
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
    );
  }
}
