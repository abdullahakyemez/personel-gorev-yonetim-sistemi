import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../forms/leave_form.dart';
import '../../application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

class LeaveDetailPanel extends ConsumerWidget {
  const LeaveDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leave = ref.watch(selectedLeaveProvider);

    if (leave == null) {
      return const Center(
        child: Text('İzin seçiniz', style: TextStyle(fontSize: 16)),
      );
    }

    final personnelAsync = ref.watch(personnelListProvider);

    return personnelAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => Center(
        child: Text(
          'Personel bilgileri yüklenemedi.\n$error',
          textAlign: TextAlign.center,
        ),
      ),

      data: (personnelList) {
        final personnel = personnelList
            .where((person) => person.registryNumber == leave.personnelId)
            .firstOrNull;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leave.type.label,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Text(
                'İzin Detayı',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              _DetailRow(
                title: 'Personel',
                value: personnel?.fullName ?? 'Personel bulunamadı',
              ),

              _DetailRow(title: 'İzin Türü', value: leave.type.label),

              _DetailRow(
                title: 'Başlangıç',
                value: DateFormatter.short(leave.startDate),
              ),

              _DetailRow(
                title: 'Bitiş',
                value: DateFormatter.short(leave.endDate),
              ),

              _DetailRow(title: 'Süre', value: '${leave.dayCount} gün'),

              const Divider(height: 40),

              Text('Açıklama', style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(
                leave.description.trim().isEmpty
                    ? 'Açıklama bulunmuyor.'
                    : leave.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              width: 700,
                              child: LeaveForm(leave: leave),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Düzenle'),
                  ),

                  const SizedBox(width: 12),

                  FilledButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('İzin Sil'),
                            content: Text(
                              '${leave.type.label} kaydını silmek istediğinize emin misiniz?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Vazgeç'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Sil'),
                              ),
                            ],
                          );
                        },
                      );

                      if (result != true) {
                        return;
                      }

                      await ref
                          .read(leaveControllerProvider.notifier)
                          .deleteLeave(leave.id);

                      ref.read(selectedLeaveIdProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Sil'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
