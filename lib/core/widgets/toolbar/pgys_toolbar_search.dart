import 'package:flutter/material.dart';

class PGYSSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const PGYSSearchField({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
