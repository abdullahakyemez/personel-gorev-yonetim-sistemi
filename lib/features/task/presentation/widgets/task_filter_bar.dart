import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_priority_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_priority.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class TaskFilterBar extends ConsumerStatefulWidget {
  const TaskFilterBar({super.key});

  @override
  ConsumerState<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends ConsumerState<TaskFilterBar> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelListProvider);

    return Column(
      children: [
        PGYSTextField(
          label: "Görev Ara",
          hintText: "Başlık veya açıklama",
          prefixIcon: const Icon(Icons.search),
          controller: searchController,
          onChanged: (value) {
            ref.read(taskSearchProvider.notifier).state = value;
          },
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: PGYSDropdownField<TaskStatus>(
                label: "Durum",
                hint: "Tümü",
                value: ref.watch(selectedTaskStatusProvider),
                items: TaskStatus.values,
                labelBuilder: (e) => e.label,
                onChanged: (value) {
                  ref.read(selectedTaskStatusProvider.notifier).state = value;
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: PGYSDropdownField<TaskPriority>(
                label: "Öncelik",
                hint: "Tümü",
                value: ref.watch(selectedTaskPriorityProvider),
                items: TaskPriority.values,
                labelBuilder: (e) => e.label,
                onChanged: (value) {
                  ref.read(selectedTaskPriorityProvider.notifier).state = value;
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: personnelAsync.when(
                data: (list) {
                  return PGYSDropdownField<String>(
                    label: "Personel",
                    hint: "Tümü",
                    value: ref.watch(selectedPersonnelProvider),
                    items: list.map((e) => e.registryNumber).toList(),
                    labelBuilder: (id) {
                      return list
                          .firstWhere((e) => e.registryNumber == id)
                          .fullName;
                    },
                    onChanged: (value) {
                      ref.read(selectedPersonnelProvider.notifier).state =
                          value;
                    },
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Filtreleri Temizle"),
            onPressed: () {
              searchController.clear();

              ref.read(taskSearchProvider.notifier).state = "";

              ref.read(selectedTaskStatusProvider.notifier).state = null;

              ref.read(selectedTaskPriorityProvider.notifier).state = null;

              ref.read(selectedPersonnelProvider.notifier).state = null;

              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
