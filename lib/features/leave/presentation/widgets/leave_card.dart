import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

class LeaveCard extends ConsumerWidget {
  final Leave leave;
  final bool selected;
  final VoidCallback? onTap;

  const LeaveCard({
    super.key,
    required this.leave,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      leave.type.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  Text(
                    '${leave.dayCount} gün',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              personnelAsync.when(
                loading: () => const SizedBox.shrink(),

                error: (_, _) => const Text('Personel bilgisi alınamadı'),

                data: (personnelList) {
                  final person = personnelList
                      .where(
                        (person) => person.registryNumber == leave.personnelId,
                      )
                      .firstOrNull;

                  return Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          person?.fullName ?? 'Personel bulunamadı',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${DateFormatter.short(leave.startDate)}'
                    ' - '
                    '${DateFormatter.short(leave.endDate)}',
                  ),
                ],
              ),

              if (leave.description.trim().isNotEmpty) ...[
                const SizedBox(height: 10),

                Text(
                  leave.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
