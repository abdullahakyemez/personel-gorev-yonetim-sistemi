import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/tabs/pgys_tab_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/tabs/pgys_tab_item.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_tab_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;

class PersonnelDetailTabs extends ConsumerWidget {
  const PersonnelDetailTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedPersonnelTabProvider);
    final person = ref.watch(selectedPersonnelProvider);
    void changeTab(PersonnelDetailTab tab) {
      ref.read(selectedPersonnelTabProvider.notifier).state = tab;
    }

    final taskCount = ref.watch(taskControllerProvider).value?.where((t) {
      return person?.id != null && t.personnelIds.contains(person!.id);
    }).length ?? 0;

    final leaveCount = ref.watch(leaveControllerProvider).value?.where((l) {
      return person?.id != null && l.personnelId == person!.id;
    }).length ?? 0;

    return PGYSTabBar(
      tabs: [
        PGYSTabItem(
          title: 'Genel Bilgiler',
          icon: Icons.person_outline_rounded,
          selected: selectedTab == PersonnelDetailTab.general,
          onTap: () => changeTab(PersonnelDetailTab.general),
        ),
        PGYSTabItem(
          title: 'Görevler',
          badgeText: '$taskCount',
          icon: Icons.calendar_month_outlined,
          selected: selectedTab == PersonnelDetailTab.tasks,
          onTap: () => changeTab(PersonnelDetailTab.tasks),
        ),
        PGYSTabItem(
          title: 'İzinler',
          badgeText: '$leaveCount',
          icon: Icons.description_outlined,
          selected: selectedTab == PersonnelDetailTab.leaves,
          onTap: () => changeTab(PersonnelDetailTab.leaves),
        ),
        PGYSTabItem(
          title: 'Hareketler',
          icon: Icons.history_rounded,
          selected: selectedTab == PersonnelDetailTab.history,
          onTap: () => changeTab(PersonnelDetailTab.history),
        ),
      ],
    );
  }
}
