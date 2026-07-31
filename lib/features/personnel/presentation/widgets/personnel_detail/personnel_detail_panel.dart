import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_tab_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_detail_tabs.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_profile_card.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/tabs/general_information_tab.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/tabs/history_tab.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/tabs/leaves_tab.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/tabs/tasks_tab.dart';

class PersonnelDetailPanel extends ConsumerWidget {
  const PersonnelDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(selectedPersonnelProvider);

    if (person == null) {
      return const Center(child: Text('Bir personel seçiniz'));
    }

    final selectedTab = ref.watch(selectedPersonnelTabProvider);

    Widget content;

    switch (selectedTab) {
      case PersonnelDetailTab.general:
        content = GeneralInformationTab(person: person);

      case PersonnelDetailTab.tasks:
        content = const TasksTab();

      case PersonnelDetailTab.leaves:
        content = const LeavesTab();

      case PersonnelDetailTab.history:
        content = const HistoryTab();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: PGYSCard(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonnelProfileCard(person: person),

            const SizedBox(height: 24),

            const PersonnelDetailTabs(),

            const Divider(height: 32),

            content,
          ],
        ),
      ),
    );
  }
}
