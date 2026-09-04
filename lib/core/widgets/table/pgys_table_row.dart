import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_checkbox.dart';

class PGYSTableRow extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final int index;
  final bool selected;
  final bool showCheckbox;
  final bool checked;
  final ValueChanged<bool?>? onCheckedChanged;
  final VoidCallback? onDoubleTap;
  final GestureTapDownCallback? onSecondaryTapDown;

  const PGYSTableRow({
    super.key,
    required this.children,
    this.onTap,
    required this.index,
    this.selected = false,
    this.showCheckbox = false,
    this.checked = false,
    this.onCheckedChanged,
    this.onDoubleTap,
    this.onSecondaryTapDown,
  });
  @override
  State<PGYSTableRow> createState() => _PGYSTableRowState();
}

class _PGYSTableRowState extends State<PGYSTableRow> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => hovering = true);
      },
      onExit: (_) {
        setState(() => hovering = false);
      },
      child: InkWell(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onSecondaryTapDown: widget.onSecondaryTapDown,
        hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),

          decoration: BoxDecoration(
            color: widget.selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                : hovering
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.03)
                : widget.index.isEven
                ? Theme.of(context).colorScheme.surfaceContainerLow
                : Theme.of(context).colorScheme.surface,
            border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
          ),

          child: Row(
            children: [
              if (widget.showCheckbox)
                PGYSTableCheckbox(
                  visible: hovering || widget.checked,
                  value: widget.checked,
                  onChanged: widget.onCheckedChanged,
                ),
              ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}
