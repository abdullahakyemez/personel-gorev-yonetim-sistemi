import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/domain/models/dashboard_stat_card_data.dart';

class DashboardStatCard extends StatelessWidget {
  final DashboardStatCardData data;

  const DashboardStatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: data.color.withValues(alpha: 0.12),
              child: Icon(data.icon, color: data.color),
            ),

            const SizedBox(height: 18),

            Text(data.title, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 8),

            Text(data.value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
