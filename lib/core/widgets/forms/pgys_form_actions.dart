import 'package:flutter/material.dart';

class PGYSFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool saveEnabled;
  final String saveText;

  const PGYSFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.saveEnabled = true,
    this.saveText = "Kaydet",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(onPressed: onCancel, child: const Text("İptal")),

        const SizedBox(width: 12),

        FilledButton(
          onPressed: saveEnabled ? onSave : null,
          child: Text(saveText),
        ),
      ],
    );
  }
}
