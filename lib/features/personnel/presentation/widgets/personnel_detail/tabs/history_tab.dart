import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';

class HistoryTab extends ConsumerWidget {
  final Personnel person;

  const HistoryTab({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      personnelHistoryProvider(person.registryNumber),
    );

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Geçmiş kayıtları yüklenemedi.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
      data: (history) => _HistoryContent(history: history),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  final List<PersonnelHistory> history;

  const _HistoryContent({required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İşlem Geçmişi',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Personel ile ilgili oluşturma, güncelleme, izin ve görev hareketleri.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        if (history.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Henüz geçmiş kaydı bulunmuyor.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _HistoryTile(item: history[index]);
            },
          ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final PersonnelHistory item;

  const _HistoryTile({required this.item});

  String _label(PersonnelHistoryAction action) {
    switch (action) {
      case PersonnelHistoryAction.personnelCreated:
        return 'Personel Oluşturuldu';
      case PersonnelHistoryAction.personnelUpdated:
        return 'Personel Güncellendi';
      case PersonnelHistoryAction.personnelDeleted:
        return 'Personel Silindi';
      case PersonnelHistoryAction.leaveAdded:
        return 'İzin Eklendi';
      case PersonnelHistoryAction.leaveUpdated:
        return 'İzin Güncellendi';
      case PersonnelHistoryAction.leaveDeleted:
        return 'İzin Silindi';
      case PersonnelHistoryAction.taskAdded:
        return 'Görev Eklendi';
      case PersonnelHistoryAction.taskUpdated:
        return 'Görev Güncellendi';
      case PersonnelHistoryAction.taskAssigned:
        return 'Görev Atandı';
      case PersonnelHistoryAction.taskUnassigned:
        return 'Görev Ataması Kaldırıldı';
      case PersonnelHistoryAction.taskDeleted:
        return 'Görev Silindi';
    }
  }

  IconData _icon(PersonnelHistoryAction action) {
    switch (action) {
      case PersonnelHistoryAction.personnelCreated:
        return Icons.person_add_alt_1_outlined;
      case PersonnelHistoryAction.personnelUpdated:
        return Icons.manage_accounts_outlined;
      case PersonnelHistoryAction.personnelDeleted:
        return Icons.person_remove_outlined;
      case PersonnelHistoryAction.leaveAdded:
      case PersonnelHistoryAction.leaveUpdated:
        return Icons.event_available_outlined;
      case PersonnelHistoryAction.leaveDeleted:
        return Icons.event_busy_outlined;
      case PersonnelHistoryAction.taskAdded:
        return Icons.assignment_outlined;
      case PersonnelHistoryAction.taskUpdated:
        return Icons.edit_note_outlined;
      case PersonnelHistoryAction.taskAssigned:
        return Icons.assignment_ind_outlined;
      case PersonnelHistoryAction.taskUnassigned:
        return Icons.person_off_outlined;
      case PersonnelHistoryAction.taskDeleted:
        return Icons.delete_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      leading: CircleAvatar(child: Icon(_icon(item.action), size: 20)),
      title: Text(
        _label(item.action),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(item.description),
      ),
      trailing: Text(
        '${DateFormatter.short(item.createdAt)}\n${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}',
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
