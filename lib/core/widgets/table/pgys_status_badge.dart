import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class PGYSStatusBadge extends StatelessWidget {
  final PersonnelStatus status;

  const PGYSStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  _StatusConfig _getConfig(PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return const _StatusConfig(label: "Görevde", color: Colors.green);

      case PersonnelStatus.resting:
        return const _StatusConfig(label: "İstirahatli", color: Colors.orange);

      case PersonnelStatus.leave:
        return const _StatusConfig(label: "İzinli", color: Colors.blue);

      case PersonnelStatus.sickReport:
        return const _StatusConfig(label: "Raporlu", color: Colors.red);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;

  const _StatusConfig({required this.label, required this.color});
}
