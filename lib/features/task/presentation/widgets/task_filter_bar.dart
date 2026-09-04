import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class TaskFilterBar extends ConsumerWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(taskSearchProvider);
    final selectedStatus = ref.watch(selectedTaskStatusProvider);
    final selectedPersonnel = ref.watch(selectedPersonnelProvider);
    final selectedCategory = ref.watch(selectedTaskCategoryProvider);

    final personnelAsync = ref.watch(personnelListProvider);

    final hasFilter =
        search.isNotEmpty ||
        selectedStatus != null ||
        selectedPersonnel != null ||
        selectedCategory != null;

    return Row(
      children: [
        // ------------------------------------------------------------
        // ARAMA
        // ------------------------------------------------------------
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Görev, açıklama, personel veya sicil ara...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        ref.read(taskSearchProvider.notifier).state = '';
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              ref.read(taskSearchProvider.notifier).state = value;
            },
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------------
        // DURUM
        // ------------------------------------------------------------
        SizedBox(
          width: 190,
          child: DropdownButtonFormField<TaskStatus?>(
            initialValue: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Durum',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<TaskStatus?>(
                value: null,
                child: Text('Tüm Durumlar'),
              ),
              ...[TaskStatus.inProgress, TaskStatus.completed].map(
                (status) => DropdownMenuItem<TaskStatus?>(
                  value: status,
                  child: Text(status.label),
                ),
              ),
            ],
            onChanged: (value) {
              ref.read(selectedTaskStatusProvider.notifier).state = value;
            },
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------------
        // GÖREV TÜRÜ
        // ------------------------------------------------------------
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<TaskCategory?>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(labelText: 'Görev Türü', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem<TaskCategory?>(value: null, child: Text('Tüm Görev Türleri')),
              ...TaskCategory.values.map((category) => DropdownMenuItem<TaskCategory?>(value: category, child: Text(category.label))),
            ],
            onChanged: (value) => ref.read(selectedTaskCategoryProvider.notifier).state = value,
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------------
        // PERSONEL
        // ------------------------------------------------------------
        SizedBox(
          width: 220,
          child: personnelAsync.when(
            loading: () => const InputDecorator(
              decoration: InputDecoration(
                labelText: 'Personel',
                border: OutlineInputBorder(),
              ),
              child: Text('Yükleniyor...'),
            ),
            error: (_, _) => const InputDecorator(
              decoration: InputDecoration(
                labelText: 'Personel',
                border: OutlineInputBorder(),
              ),
              child: Text('Yüklenemedi'),
            ),
            data: (personnelList) {
              return DropdownButtonFormField<String?>(
                initialValue: selectedPersonnel,
                decoration: const InputDecoration(
                  labelText: 'Personel',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tüm Personel'),
                  ),
                  ...personnelList.map(
                    (person) => DropdownMenuItem<String?>(
                      value: person.registryNumber,
                      child: Text(person.fullName),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(selectedPersonnelProvider.notifier).state = value;
                },
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------------
        // TEMİZLE
        // ------------------------------------------------------------
        if (hasFilter)
          IconButton(
            tooltip: 'Filtreleri temizle',
            onPressed: () {
              ref.read(taskSearchProvider.notifier).state = '';
              ref.read(selectedTaskStatusProvider.notifier).state = null;
              ref.read(selectedPersonnelProvider.notifier).state = null;
              ref.read(selectedTaskCategoryProvider.notifier).state = null;
            },
            icon: const Icon(Icons.filter_alt_off),
          ),
      ],
    );
  }
}
