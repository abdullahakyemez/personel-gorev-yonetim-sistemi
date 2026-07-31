import 'package:flutter/material.dart';

import 'pgys_table_cell.dart';

class PGYSTableHeaderCell extends StatelessWidget {
  final String title;
  final int flex;
  final bool sortable;
  final TextAlign textAlign;
  final VoidCallback? onSort;
  final IconData? sortIcon;

  const PGYSTableHeaderCell({
    super.key,
    required this.title,
    this.flex = 1,
    this.sortable = false,
    this.textAlign = TextAlign.left,
    this.onSort,
    this.sortIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSTableCell(
      flex: flex,
      isHeader: true,
      child: InkWell(
        onTap: sortable ? onSort : null,
        borderRadius: BorderRadius.circular(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, textAlign: textAlign),
            if (sortable) ...[
              const SizedBox(width: 4),

              Icon(sortIcon ?? Icons.unfold_more, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
