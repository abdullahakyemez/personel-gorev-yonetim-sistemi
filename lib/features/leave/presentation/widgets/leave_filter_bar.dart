import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/dialogs/leave_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

class LeaveFilterBar extends ConsumerStatefulWidget {
  const LeaveFilterBar({super.key});

  @override
  ConsumerState<LeaveFilterBar> createState() => _LeaveFilterBarState();
}

class _LeaveFilterBarState extends ConsumerState<LeaveFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(leaveSearchProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    ref.read(leaveSearchProvider.notifier).state = '';
    ref.read(selectedLeaveTypeProvider.notifier).state = null;
    ref.read(selectedLeavePersonnelProvider.notifier).state = null;
    ref.read(leaveStartDateFilterProvider.notifier).state = null;
    ref.read(leaveEndDateFilterProvider.notifier).state = null;
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(leaveSearchProvider, (previous, next) {
      if (_searchController.text != next) {
        _searchController.text = next;
      }
    });

    final search = ref.watch(leaveSearchProvider);
    final personnelAsync = ref.watch(personnelListProvider);
    final selectedLeaveType = ref.watch(selectedLeaveTypeProvider);
    final selectedPersonnel = ref.watch(selectedLeavePersonnelProvider);
    final canCreateLeave = ref.watch(hasPermissionProvider(AppPermission.createLeave));

    final hasFilter = search.isNotEmpty ||
        selectedLeaveType != null ||
        selectedPersonnel != null;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6),
      ),
    );

    return PGYSCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 1. ARAMA INPUT
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Personel veya Açıklama Ara...',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            ref.read(leaveSearchProvider.notifier).state = '';
                            _searchController.clear();
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                  ref.read(leaveSearchProvider.notifier).state = value;
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. İZİN TÜRLERİ
          SizedBox(
            width: 160,
            height: 40,
            child: DropdownButtonFormField<LeaveType?>(
              initialValue: selectedLeaveType,
              isExpanded: true,
              style: TextStyle(
                fontSize: 12.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
              ),
              items: [
                const DropdownMenuItem<LeaveType?>(
                  value: null,
                  child: Text('Tüm İzin Türleri'),
                ),
                ...LeaveType.values.map(
                  (type) => DropdownMenuItem<LeaveType?>(
                    value: type,
                    child: Text(type.label),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(selectedLeaveTypeProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 12),

          // 3. PERSONEL
          SizedBox(
            width: 190,
            height: 40,
            child: personnelAsync.when(
              loading: () => const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, _) => const SizedBox(),
              data: (list) {
                return DropdownButtonFormField<int?>(
                  initialValue: selectedPersonnel,
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Personele Göre Filtrele'),
                    ),
                    ...list.map(
                      (p) => DropdownMenuItem<int?>(
                        value: p.id,
                        child: Text(
                          p.fullName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    ref.read(selectedLeavePersonnelProvider.notifier).state = val;
                  },
                );
              },
            ),
          ),

          // 4. TEMİZLE BUTONU
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Filtreleri Temizle',
            icon: Icon(
              Icons.filter_alt_off,
              size: 20,
              color: hasFilter
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
            onPressed: hasFilter ? _clearFilters : null,
          ),

          const Spacer(),

          // 5. EXCEL AKTAR BUTONU (#00875A)
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF00875A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            icon: const Icon(Icons.table_chart_outlined, size: 16),
            label: const Text(
              'Excel Aktar',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            onPressed: () async {
              final leavesAsync = ref.read(filteredLeaveProvider);
              final personnelList = personnelAsync.value ?? [];
              final leaves = leavesAsync.value ?? [];
              if (leaves.isEmpty) {
                PGYSFeedback.showWarning(context, 'Dışa aktarılacak izin kaydı bulunamadı.');
                return;
              }
              await LeaveExcelExportService().exportAndSave(
                leaves: leaves,
                personnel: personnelList,
              );
              if (context.mounted) {
                PGYSFeedback.showSuccess(context, 'İzin listesi Excel dosyası olarak indirildi.');
              }
            },
          ),

          // 6. İZİN / RAPOR EKLE BUTONU (#0F2027)
          if (canCreateLeave) ...[
            const SizedBox(width: 10),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F2027),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              icon: const Icon(Icons.note_add_outlined, size: 16),
              label: const Text(
                'İzin / Rapor Ekle',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              onPressed: () async {
                await showLeaveDialog(context);
              },
            ),
          ],
        ],
      ),
    );
  }
}
