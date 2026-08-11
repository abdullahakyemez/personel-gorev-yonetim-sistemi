import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_primary_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_danger_button.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
//import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_assignment_provider.dart';

class PersonnelProfileCard extends ConsumerWidget {
  final Personnel person;

  const PersonnelProfileCard({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final assignment = ref.watch(taskAssignmentProvider(person.registryNumber));
    return PGYSCard(
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: person.status == PersonnelStatus.duty
                    ? Colors.green.withValues(alpha: .12)
                    : Colors.red.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: person.status == PersonnelStatus.duty
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    person.status == PersonnelStatus.duty
                        ? 'Görevde'
                        : 'Görevde Değil',
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
                backgroundColor: AppColors.primary.withValues(alpha: .10),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.primary,
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
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        SizedBox(width: 4),
                        Text(" / "),
                        SizedBox(width: 4),
                        Text(
                          person.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    /*Text(
                      person.rank,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
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
                          backgroundColor: Colors.blueGrey.withValues(
                            alpha: .15,
                          ),
                          side: BorderSide.none,
                        ),

                        Chip(
                          avatar: const Icon(Icons.business_outlined, size: 18),
                          label: Text(person.branch),
                          backgroundColor: Colors.blueGrey.withValues(
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
                          backgroundColor: Colors.blueGrey.withValues(
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
