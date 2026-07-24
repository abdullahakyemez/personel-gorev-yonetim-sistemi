import 'package:flutter/material.dart';

class PGYSTabBar extends StatelessWidget {
  final List<Widget> tabs;

  const PGYSTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: tabs);
  }
}
