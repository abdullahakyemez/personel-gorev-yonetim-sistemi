import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';

class PersonnelFilterBar extends ConsumerStatefulWidget {
  const PersonnelFilterBar({super.key});

  @override
  ConsumerState<PersonnelFilterBar> createState() => _PersonnelFilterBarState();
}

class _PersonnelFilterBarState extends ConsumerState<PersonnelFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(personnelSearchProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    ref.read(personnelSearchProvider.notifier).state = '';
    ref.read(selectedRankProvider.notifier).state = null;
    ref.read(selectedBranchProvider.notifier).state = null;
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(personnelSearchProvider, (previous, next) {
      if (_searchController.text != next) {
        _searchController.text = next;
      }
    });

    final search = ref.watch(personnelSearchProvider);
    final selectedRank = ref.watch(selectedRankProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);
    final canCreatePersonnel = ref.watch(
      hasPermissionProvider(AppPermission.createPersonnel),
    );
    final canExportReports = ref.watch(
      hasPermissionProvider(AppPermission.exportReports),
    );

    final hasFilter =
        search.isNotEmpty || selectedRank != null || selectedBranch != null;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.6),
      ),
    );

    return PGYSCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1050;

          final searchWidget = SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Personel Ara...',
                hintStyle: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          ref.read(personnelSearchProvider.notifier).state = '';
                          _searchController.clear();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder.copyWith(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) {
                ref.read(personnelSearchProvider.notifier).state = value;
              },
            ),
          );

          final rankWidget = SizedBox(
            width: 170,
            height: 40,
            child: DropdownButtonFormField<String?>(
              initialValue: selectedRank,
              isExpanded: true,
              style: TextStyle(
                fontSize: 12.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Tüm Rütbeler'),
                ),
                ...PersonnelLookup.ranks.map(
                  (rank) => DropdownMenuItem<String?>(
                    value: rank,
                    child: Text(rank, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(selectedRankProvider.notifier).state = value;
              },
            ),
          );

          final branchWidget = SizedBox(
            width: 200,
            height: 40,
            child: DropdownButtonFormField<String?>(
              initialValue: selectedBranch,
              isExpanded: true,
              style: TextStyle(
                fontSize: 12.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Tüm Bürolar'),
                ),
                ...PersonnelLookup.branches.map(
                  (branch) => DropdownMenuItem<String?>(
                    value: branch,
                    child: Text(branch, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(selectedBranchProvider.notifier).state = value;
              },
            ),
          );

          final clearButton = IconButton(
            tooltip: 'Filtreleri Temizle',
            icon: Icon(
              Icons.filter_alt_off,
              size: 20,
              color: hasFilter
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
            onPressed: hasFilter ? _clearFilters : null,
          );

          final excelButton = canExportReports
              ? FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00875A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.table_chart_outlined, size: 16),
                  label: const Text(
                    'Excel Aktar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final allPersonnel = await ref.read(
                        personnelListProvider.future,
                      );
                      if (allPersonnel.isEmpty) {
                        if (!context.mounted) return;
                        PGYSFeedback.showWarning(
                          context,
                          'Dışa aktarılacak personel bulunamadı.',
                        );
                        return;
                      }
                      final path = await PersonnelExcelExportService().export(
                        personnel: allPersonnel,
                      );
                      if (!context.mounted || path == null) return;
                      PGYSFeedback.showSuccess(
                        context,
                        'Tüm personel Excel dosyası kaydedildi: $path',
                      );
                    } catch (error) {
                      if (!context.mounted) return;
                      PGYSFeedback.showError(
                        context,
                        'Excel aktarımı başarısız: $error',
                      );
                    }
                  },
                )
              : null;

          final addPersonnelButton = canCreatePersonnel
              ? FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2027),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'Personel Ekle',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () {
                    showAddPersonnelDialog(context);
                  },
                )
              : null;

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: searchWidget),
                const SizedBox(width: AppSpacing.sm),
                rankWidget,
                const SizedBox(width: AppSpacing.sm),
                branchWidget,
                const SizedBox(width: 6),
                clearButton,
                const Spacer(),
                ?excelButton,
                if (addPersonnelButton != null) ...[
                  if (excelButton != null) const SizedBox(width: AppSpacing.sm),
                  addPersonnelButton,
                ],
              ],
            );
          }

          return Wrap(
            spacing: 8,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth < 600 ? constraints.maxWidth : 260,
                child: searchWidget,
              ),
              rankWidget,
              branchWidget,
              clearButton,
              ?excelButton,
              ?addPersonnelButton,
            ],
          );
        },
      ),
    );
  }
}
