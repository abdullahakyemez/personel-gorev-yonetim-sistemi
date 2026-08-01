import 'package:flutter/material.dart';

class PGYSToolbar extends StatelessWidget {
  final Widget child;

  const PGYSToolbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: child,
    );
  }
}
