import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_primary_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_danger_button.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
//import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_assignment_provider.dart';

class PersonnelProfileCard extends ConsumerWidget {
  final Personnel person;

  const PersonnelProfileCard({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(leaveControllerProvider);

    final currentStatus = leavesAsync.when(
      data: (leaves) => PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
      ),
      loading: () => person.status,
      error: (_, _) => person.status,
    );

    final isDuty = currentStatus == PersonnelStatus.duty;
    final statusText = switch (currentStatus) {
      PersonnelStatus.duty => 'Görevde',
      PersonnelStatus.resting => 'İstirahatli',
      PersonnelStatus.leave => 'İzinli',
      PersonnelStatus.sickReport => 'Raporlu',
    };

    return PGYSCard(
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDuty
                    ? Theme.of(context).colorScheme.secondary.withValues(alpha: .12)
                    : Theme.of(context).colorScheme.error.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: isDuty
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
                child: Icon(
                  Icons.person,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.fullName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Text(
                          person.rank,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        SizedBox(width: 4),
                        Text(" / "),
                        SizedBox(width: 4),
                        Text(
                          person.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),

                    /*Text(
                      person.rank,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),*/
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.badge_outlined, size: 18),
                          label: Text(person.registryNumber),
                          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                            alpha: .15,
                          ),
                          side: BorderSide.none,
                        ),

                        Chip(
                          avatar: const Icon(Icons.business_outlined, size: 18),
                          label: Text(person.branch),
                          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                            alpha: .15,
                          ),
                          side: BorderSide.none,
                        ),

                        Chip(
                          avatar: const Icon(
                            Icons.account_tree_outlined,
                            size: 18,
                          ),
                          label: Text(person.department),
                          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                            alpha: .15,
                          ),
                          side: BorderSide.none,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: PGYSPrimaryButton(
                            text: 'Düzenle',
                            icon: Icons.edit,
                            onPressed: () {
                              showEditPersonnelDialog(context, person);
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: PgysDangerButton(
                            text: 'Sil',
                            icon: Icons.delete_outline_rounded,
                            onPressed: () {
                              showDeletePersonnelDialog(context, ref, person);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
