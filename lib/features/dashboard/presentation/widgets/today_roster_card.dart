import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
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
    final theme = Theme.of(context);

    return SectionCard(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.people_outline_rounded,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: 'Bugünkü Kadro Durumu',
      subtitle: 'Çalışma takvimi ve izin/rapor kayıtlarına göre anlık personel mevcudu',
      trailing: TextButton.icon(
        onPressed: () => context.go('/personeller'),
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: const Text(
          'Tüm Kadroyu Gör',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      child: rosterAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(error.toString()),
        ),
        data: (roster) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 2
                      : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 16) / columns;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.duty,
                    indicatorColor: const Color(0xFF00C853),
                    emptyLabel: 'Görevde personel',
                    people: roster.duty,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.resting,
                    indicatorColor: const Color(0xFF1E88E5),
                    emptyLabel: 'İstirahatli personel',
                    people: roster.resting,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.leave,
                    indicatorColor: const Color(0xFFFF9800),
                    emptyLabel: 'İzinli personel',
                    people: roster.leave,
                  ),
                  _RosterColumn(
                    width: width,
                    status: PersonnelStatus.sickReport,
                    indicatorColor: const Color(0xFFE53935),
                    emptyLabel: 'Raporlu personel',
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
  final Color indicatorColor;
  final String emptyLabel;
  final List<Personnel> people;

  const _RosterColumn({
    required this.width,
    required this.status,
    required this.indicatorColor,
    required this.emptyLabel,
    required this.people,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${status.label.toUpperCase()} (${people.length})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(
            height: 1,
            color: indicatorColor.withValues(alpha: 0.25),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 270,
            child: people.isEmpty
                ? Center(
                    child: Text(
                      '$emptyLabel yok',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : Scrollbar(
                    thumbVisibility: people.length > 3,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 6, top: 2, bottom: 2),
                      itemCount: people.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final person = people[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            if (person.id != null) {
                              ref.read(selectedPersonnelIdProvider.notifier).state =
                                  person.id;
                            }
                            context.go('/personeller');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        person.fullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceContainerHighest
                                            .withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        person.registryNumber,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        person.rank,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      person.title.isNotEmpty
                                          ? person.title
                                          : person.branch,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
