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

    return PGYSTabBar(
      tabs: [
        PGYSTabItem(
          title: 'Genel Bilgiler',
          selected: selectedTab == PersonnelDetailTab.general,
          onTap: () {
            ref.read(selectedPersonnelTabProvider.notifier).state =
                PersonnelDetailTab.general;
          },
        ),
        PGYSTabItem(
          title: 'Görevler',
          selected: selectedTab == PersonnelDetailTab.tasks,
          onTap: () {
            ref.read(selectedPersonnelTabProvider.notifier).state =
                PersonnelDetailTab.tasks;
          },
        ),
        PGYSTabItem(
          title: 'İzinler',
          selected: selectedTab == PersonnelDetailTab.leaves,
          onTap: () {
            ref.read(selectedPersonnelTabProvider.notifier).state =
                PersonnelDetailTab.leaves;
          },
        ),
        PGYSTabItem(
          title: 'Evraklar',
          selected: selectedTab == PersonnelDetailTab.documents,
          onTap: () {
            ref.read(selectedPersonnelTabProvider.notifier).state =
                PersonnelDetailTab.documents;
          },
        ),
        PGYSTabItem(
          title: 'Disiplin',
          selected: selectedTab == PersonnelDetailTab.discipline,
          onTap: () {
            ref.read(selectedPersonnelTabProvider.notifier).state =
                PersonnelDetailTab.discipline;
          },
        ),
      ],
    );
  }
}
