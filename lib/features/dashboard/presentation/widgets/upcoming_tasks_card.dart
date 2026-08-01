import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/section_card.dart';

import '../../data/mock/upcoming_tasks_data.dart';
import 'upcoming_task_item.dart';

class UpcomingTaskCard extends StatelessWidget {
  const UpcomingTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Yaklaşan Görevler",
      height: 330,

      child: Column(
        children: upcomingTasks.map((e) => UpcomingTaskItem(task: e)).toList(),
      ),
    );
  }
}
