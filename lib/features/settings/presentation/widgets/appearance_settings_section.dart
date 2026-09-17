import 'package:flutter/material.dart';
import '../../domain/models/app_settings.dart';

class AppearanceSettingsSection extends StatelessWidget {
  final AppSettings settings;
  final Future<void> Function(AppSettings) onSave;

  const AppearanceSettingsSection({
    super.key,
    required this.settings,
    required this.onSave,
  });

  String _label(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => 'Sistem',
        AppThemeMode.light => 'Açık',
        AppThemeMode.dark => 'Koyu',
      };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AppThemeMode>(
      isExpanded: true,
      initialValue: settings.themeMode,
      decoration: const InputDecoration(
        labelText: 'Tema',
        border: OutlineInputBorder(),
      ),
      items: AppThemeMode.values
          .map((mode) => DropdownMenuItem(
                value: mode,
                child: Text(_label(mode)),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onSave(settings.copyWith(themeMode: value));
        }
      },
    );
  }
}
