import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final bool selected;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnelAsync = ref.watch(personnelListProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: PGYSCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------
              // BAŞLIK
              // ----------------------------------------------------------
              Text(task.title, style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 8),

              // ----------------------------------------------------------
              // AÇIKLAMA
              // ----------------------------------------------------------
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // ----------------------------------------------------------
              // DURUM
              // ----------------------------------------------------------
              Row(
                children: [
                  Icon(task.status.icon, color: task.status.color, size: 18),
                  const SizedBox(width: 4),
                  Text(task.status.label),
                ],
              ),

              const SizedBox(height: 12),

              // ----------------------------------------------------------
              // PERSONELLER
              // ----------------------------------------------------------
              personnelAsync.when(
                loading: () => const SizedBox.shrink(),

                error: (_, _) => const Text('Personel bilgisi alınamadı'),

                data: (personnelList) {
                  final assignedPersonnel = personnelList
                      .where(
                        (personnel) =>
                            personnel.id != null &&
                            task.personnelIds.contains(personnel.id),
                      )
                      .toList();

                  if (assignedPersonnel.isEmpty) {
                    return const Text('Personel atanmadı');
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_outline, size: 18),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          assignedPersonnel
                              .map((personnel) => personnel.fullName)
                              .join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
