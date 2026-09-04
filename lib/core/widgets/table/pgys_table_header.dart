import 'package:flutter/material.dart';


class PGYSTableHeader extends StatelessWidget {
  final List<Widget> children;

  const PGYSTableHeader({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: Row(children: children),
    );
  }
}
