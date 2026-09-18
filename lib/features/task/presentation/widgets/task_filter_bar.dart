import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/task_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/dialogs/task_dialog.dart';

class TaskFilterBar extends ConsumerStatefulWidget {
  const TaskFilterBar({super.key});

  @override
  ConsumerState<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends ConsumerState<TaskFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: ref.read(taskSearchProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    ref.read(taskSearchProvider.notifier).state = '';
    ref.read(selectedTaskStatusProvider.notifier).state = null;
    ref.read(selectedPersonnelProvider.notifier).state = null;
    ref.read(selectedTaskCategoryProvider.notifier).state = null;
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(taskSearchProvider, (previous, next) {
      if (_searchController.text != next) {
        _searchController.text = next;
      }
    });

    final search = ref.watch(taskSearchProvider);
    final selectedStatus = ref.watch(selectedTaskStatusProvider);
    final selectedPersonnel = ref.watch(selectedPersonnelProvider);
    final selectedCategory = ref.watch(selectedTaskCategoryProvider);
    final personnelAsync = ref.watch(personnelListProvider);
    final canCreateTask = ref.watch(hasPermissionProvider(AppPermission.createTask));

    final hasFilter = search.isNotEmpty ||
        selectedStatus != null ||
        selectedPersonnel != null ||
        selectedCategory != null;

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
                  hintText: 'Görev Adı veya Açıklama Ara...',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            ref.read(taskSearchProvider.notifier).state = '';
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
                  ref.read(taskSearchProvider.notifier).state = value;
                },
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 2. KATEGORİLER
          SizedBox(
            width: 155,
            height: 40,
            child: DropdownButtonFormField<TaskCategory?>(
              initialValue: selectedCategory,
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
                const DropdownMenuItem<TaskCategory?>(
                  value: null,
                  child: Text('Tüm Kategoriler'),
                ),
                ...TaskCategory.values.map(
                  (cat) => DropdownMenuItem<TaskCategory?>(
                    value: cat,
                    child: Text(cat.label, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(selectedTaskCategoryProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 10),

          // 3. DURUMLAR
          SizedBox(
            width: 140,
            height: 40,
            child: DropdownButtonFormField<TaskStatus?>(
              initialValue: selectedStatus,
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
              items: const [
                DropdownMenuItem<TaskStatus?>(
                  value: null,
                  child: Text('Tüm Durumlar'),
                ),
                DropdownMenuItem<TaskStatus?>(
                  value: TaskStatus.inProgress,
                  child: Text('Devam Ediyor'),
                ),
                DropdownMenuItem<TaskStatus?>(
                  value: TaskStatus.completed,
                  child: Text('Tamamlandı'),
                ),
              ],
              onChanged: (value) {
                ref.read(selectedTaskStatusProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 10),

          // 4. PERSONEL
          SizedBox(
            width: 175,
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
                    ref.read(selectedPersonnelProvider.notifier).state = val;
                  },
                );
              },
            ),
          ),

          // 5. TEMİZLE BUTONU
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

          // 6. EXCEL AKTAR BUTONU (#00875A)
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
              final tasksAsync = ref.read(filteredTaskProvider);
              final personnelList = personnelAsync.value ?? [];
              final tasks = tasksAsync.value ?? [];
              if (tasks.isEmpty) {
                PGYSFeedback.showWarning(context, 'Dışa aktarılacak görev bulunamadı.');
                return;
              }
              await TaskExcelExportService().exportAndSave(
                tasks: tasks,
                personnel: personnelList,
              );
              if (context.mounted) {
                PGYSFeedback.showSuccess(context, 'Görev listesi Excel dosyası olarak indirildi.');
              }
            },
          ),

          // 7. GÖREV EKLE BUTONU (#0F2027)
          if (canCreateTask) ...[
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
              icon: const Icon(Icons.add_task, size: 16),
              label: const Text(
                'Görev Ekle',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              onPressed: () => showTaskDialog(context),
            ),
          ],
        ],
      ),
    );
  }
}
