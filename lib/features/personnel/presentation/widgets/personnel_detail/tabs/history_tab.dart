import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Personel Hareketleri',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Bu bölüm personelin görev, izin ve durum değişikliklerini '
              'salt okunur olarak gösterecek şekilde hazırlanmıştır.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
