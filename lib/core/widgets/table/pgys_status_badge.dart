import 'package:flutter/material.dart';

class PGYSStatusBadge extends StatelessWidget {
  final bool onDuty;

  const PGYSStatusBadge({super.key, required this.onDuty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: onDuty
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        onDuty ? "Görevde" : "İzinli",
        style: TextStyle(
          color: onDuty ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
