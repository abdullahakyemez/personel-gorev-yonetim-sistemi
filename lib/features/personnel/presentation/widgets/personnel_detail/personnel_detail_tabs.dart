import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/tabs/pgys_tab_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/tabs/pgys_tab_item.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_tab_provider.dart';

class PersonnelDetailTabs extends ConsumerWidget {
  const PersonnelDetailTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedPersonnelTabProvider);
    void changeTab(PersonnelDetailTab tab) {
      ref.read(selectedPersonnelTabProvider.notifier).state = tab;
    }

    return PGYSTabBar(
      tabs: [
        PGYSTabItem(
          title: 'Genel Bilgiler',
          icon: Icons.person_outline,
          selected: selectedTab == PersonnelDetailTab.general,
          onTap: () => changeTab(PersonnelDetailTab.general),
        ),
        PGYSTabItem(
          title: 'Görevler',
          icon: Icons.assignment_outlined,
          selected: selectedTab == PersonnelDetailTab.tasks,
          onTap: () => changeTab(PersonnelDetailTab.tasks),
        ),
        PGYSTabItem(
          title: 'İzinler',
          icon: Icons.event_available_outlined,
          selected: selectedTab == PersonnelDetailTab.leaves,
          onTap: () => changeTab(PersonnelDetailTab.leaves),
        ),
        PGYSTabItem(
          title: 'Hareketler',
          icon: Icons.history,
          selected: selectedTab == PersonnelDetailTab.history,
          onTap: () => changeTab(PersonnelDetailTab.history),
        ),
      ],
    );
  }
}
