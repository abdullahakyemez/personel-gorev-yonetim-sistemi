import 'package:flutter/material.dart';

class PGYSSection extends StatelessWidget {
  final String title;
  final Widget child;

  const PGYSSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 12),

        child,

        const SizedBox(height: 24),
      ],
    );
  }
}
