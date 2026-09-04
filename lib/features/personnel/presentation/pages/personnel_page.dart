import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_detail_panel.dart';
import '../widgets/table/personnel_list_table.dart';

class PersonnelPage extends ConsumerWidget {
  const PersonnelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSelectedPersonnel = ref.watch(selectedPersonnelIdProvider) != null;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Personeller',
            subtitle: 'Personel Yönetim Ekranı',
          ),
          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: MasterDetailLayout(
              master: const PersonnelTable(),
              detail: const PersonnelDetailPanel(),
              detailVisible: hasSelectedPersonnel,
            ),
          ),
        ],
      ),
    );
  }
}
