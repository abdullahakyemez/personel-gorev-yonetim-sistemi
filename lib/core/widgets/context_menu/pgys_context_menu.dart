import 'package:flutter/material.dart';

class PGYSContextMenu<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final Widget child;

  const PGYSContextMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (_) => items,
      child: child,
    );
  }
}
