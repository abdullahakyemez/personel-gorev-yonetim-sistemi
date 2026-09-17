import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/section_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_today_roster_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/extensions/personnel_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class TodayRosterCard extends ConsumerWidget {
  const TodayRosterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(todayRosterProvider);

    return SectionCard(
      title: 'Bugünkü Kadro — ${DateFormatter.longDate(DateTime.now())}',
      child: rosterAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Text(error.toString()),
        data: (roster) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 2
                      : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.duty,
                    people: roster.duty,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.resting,
                    people: roster.resting,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.leave,
                    people: roster.leave,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.sickReport,
                    people: roster.sickReport,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _RosterColumn extends ConsumerWidget {
  final double width;
  final PersonnelStatus status;
  final List<Personnel> people;

  const _RosterColumn({
    required this.width,
    required this.status,
    required this.people,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: status.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: status.color.withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    status.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: status.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: status.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${people.length}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: status.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(
              height: 1,
              color: status.color.withValues(alpha: 0.15),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (people.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Kayıt bulunmuyor',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...people.take(8).map(
                (person) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      if (person.id != null) {
                        ref.read(selectedPersonnelIdProvider.notifier).state =
                            person.id;
                      }
                      context.go('/personeller');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: status.color.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${person.rank} ${person.fullName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (people.length > 8)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: InkWell(
                  onTap: () => context.go('/personeller'),
                  child: Text(
                    '+${people.length - 8} kişi daha...',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
