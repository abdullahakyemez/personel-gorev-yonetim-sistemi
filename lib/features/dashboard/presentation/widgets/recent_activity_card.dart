import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/section_card.dart';
import '../../data/mock/recent_activities_data.dart';
import 'recent_activity_item.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Son İşlemler",
      height: 330,
      child: Column(
        children: recentActivities
            .map((e) => RecentActivityItem(activity: e))
            .toList(),
      ),
    );
  }
}
