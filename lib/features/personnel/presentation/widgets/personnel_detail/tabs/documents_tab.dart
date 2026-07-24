import 'package:flutter/material.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: Text(
          'Evraklar modülü yakında eklenecek',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
