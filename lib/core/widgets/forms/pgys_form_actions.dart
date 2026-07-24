import 'package:flutter/material.dart';

class PGYSFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const PGYSFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(onPressed: onCancel, child: const Text("İptal")),

        const SizedBox(width: 12),

        FilledButton(onPressed: onSave, child: const Text("Kaydet")),
      ],
    );
  }
}
