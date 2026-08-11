import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';

class HistoryTab extends ConsumerWidget {
  final Personnel person;

  const HistoryTab({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(leaveControllerProvider);

    return leavesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Geçmiş bilgileri yüklenemedi.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
      data: (leaves) {
        return _HistoryContent(person: person, leaves: leaves);
      },
    );
  }
}

class _HistoryContent extends StatelessWidget {
  final Personnel person;
  final List<Leave> leaves;

  const _HistoryContent({required this.person, required this.leaves});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final startDate = DateTime(
      person.startDate.year,
      person.startDate.month,
      person.startDate.day,
    );

    final endDate = person.endDate != null
        ? DateTime(
            person.endDate!.year,
            person.endDate!.month,
            person.endDate!.day,
          )
        : today;

    final effectiveEndDate = endDate.isAfter(today) ? today : endDate;

    if (effectiveEndDate.isBefore(startDate)) {
      return const Center(child: Text('Geçmiş durum bilgisi bulunmuyor.'));
    }

    final history = <_HistoryItem>[];

    var currentDate = startDate;

    while (!currentDate.isAfter(effectiveEndDate)) {
      final status = PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
        date: currentDate,
      );

      history.add(_HistoryItem(date: currentDate, status: status));

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Aynı durumun devam ettiği günleri tek kayıt altında
    // birleştiriyoruz.
    final groupedHistory = <_HistoryItem>[];

    for (final item in history) {
      if (groupedHistory.isEmpty) {
        groupedHistory.add(item);
        continue;
      }

      final previous = groupedHistory.last;

      if (previous.status == item.status) {
        groupedHistory[groupedHistory.length - 1] = previous.copyWith(
          endDate: item.date,
        );
      } else {
        groupedHistory.add(item);
      }
    }

    // En yeni tarih üstte.
    groupedHistory.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Durum Geçmişi', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 8),

        Text(
          'Personelin çalışma düzeni, izin ve rapor kayıtlarına '
          'göre hesaplanan geçmiş durumları.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 20),

        if (groupedHistory.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Geçmiş durum bilgisi bulunmuyor.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groupedHistory.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = groupedHistory[index];

              return _HistoryTile(item: item);
            },
          ),
      ],
    );
  }
}

class _HistoryItem {
  final DateTime date;
  final DateTime? endDate;
  final PersonnelStatus status;

  const _HistoryItem({required this.date, required this.status, this.endDate});

  _HistoryItem copyWith({
    DateTime? date,
    DateTime? endDate,
    PersonnelStatus? status,
  }) {
    return _HistoryItem(
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryTile({required this.item});

  String _statusLabel(PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return 'Görevde';

      case PersonnelStatus.resting:
        return 'İstirahatli';

      case PersonnelStatus.leave:
        return 'İzinli';

      case PersonnelStatus.sickReport:
        return 'Raporlu';
    }
  }

  IconData _statusIcon(PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return Icons.work_outline;

      case PersonnelStatus.resting:
        return Icons.hotel_outlined;

      case PersonnelStatus.leave:
        return Icons.beach_access_outlined;

      case PersonnelStatus.sickReport:
        return Icons.local_hospital_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _statusLabel(item.status);

    final dateText = item.endDate == null
        ? DateFormatter.short(item.date)
        : '${DateFormatter.short(item.date)}'
              ' - '
              '${DateFormatter.short(item.endDate!)}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      leading: CircleAvatar(child: Icon(_statusIcon(item.status), size: 20)),
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(dateText),
    );
  }
}
