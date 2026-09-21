import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/section_card.dart';

import '../../application/dashboard_recent_activity_provider.dart';

import 'recent_activity_item.dart';

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(dashboardRecentActivityProvider);
    final theme = Theme.of(context);

    return SectionCard(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.history_rounded,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: "Son Sistem İşlemleri",
      subtitle: "Kayıt, izin, görev ve nöbet hareketleri",
      trailing: TextButton(
        onPressed: () => context.go('/personeller'),
        child: const Text(
          'Kadroya Git',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      height: 450,
      scrollable: true,

      child: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, _) => const Center(child: Text("Veri yüklenemedi")),

        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Henüz görev aktivitesi bulunmuyor',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: activities.length,

            itemBuilder: (_, index) {
              return RecentActivityItem(activity: activities[index]);
            },
          );
        },
      ),
    );
  }
}
