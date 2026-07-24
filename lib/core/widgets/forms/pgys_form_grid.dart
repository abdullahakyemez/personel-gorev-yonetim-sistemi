import 'package:flutter/material.dart';

class PGYSFormGrid extends StatelessWidget {
  final List<Widget> children;

  /// Her satırdaki eleman sayısı
  final int columns;

  /// Yatay boşluk
  final double horizontalSpacing;

  /// Dikey boşluk
  final double verticalSpacing;

  const PGYSFormGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.horizontalSpacing = 16,
    this.verticalSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (int i = 0; i < children.length; i += columns) {
      final rowChildren = <Widget>[];

      for (int j = 0; j < columns; j++) {
        final index = i + j;

        if (index < children.length) {
          rowChildren.add(Expanded(child: children[index]));
        } else {
          rowChildren.add(const Expanded(child: SizedBox()));
        }

        if (j != columns - 1) {
          rowChildren.add(SizedBox(width: horizontalSpacing));
        }
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );

      rows.add(SizedBox(height: verticalSpacing));
    }

    return Column(children: rows);
  }
}
