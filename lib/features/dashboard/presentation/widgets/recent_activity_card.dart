import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/section_card.dart';

import '../../application/dashboard_recent_activity_provider.dart';

import 'recent_activity_item.dart';

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(dashboardRecentActivityProvider);

    return SectionCard(
      title: "Son Görevler",
      height: 450,
      scrollable: true,

      child: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, _) => const Center(child: Text("Veri yüklenemedi")),

        data: (activities) {
          if (activities.isEmpty) {
            return const Center(child: Text("Görev bulunamadı"));
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
