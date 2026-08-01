import 'package:flutter/material.dart';

class PGYSToolbarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const PGYSToolbarButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
