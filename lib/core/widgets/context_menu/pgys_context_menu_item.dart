import 'package:flutter/material.dart';

class PGYSContextMenuItem<T> extends PopupMenuItem<T> {
  PGYSContextMenuItem({
    super.key,
    required IconData icon,
    required String title,
    required T value,
  }) : super(
         value: value,
         child: Row(
           children: [
             Icon(icon, size: 18),
             const SizedBox(width: 12),
             Text(title),
           ],
         ),
       );
}
