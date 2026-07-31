import 'package:flutter/material.dart';

class PGYSTableCheckbox extends StatelessWidget {
  final bool visible;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const PGYSTableCheckbox({
    super.key,
    required this.visible,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 150),
      offset: visible ? Offset.zero : Offset(-0.15, 0),
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: IgnorePointer(
          ignoring: !visible,
          child: Checkbox(value: value, onChanged: onChanged),
        ),
      ),
    );
  }
}
