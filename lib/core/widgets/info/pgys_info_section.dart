import 'package:flutter/material.dart';

class PGYSInfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const PGYSInfoSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 18),

            child,
          ],
        ),
      ),
    );
  }
}
