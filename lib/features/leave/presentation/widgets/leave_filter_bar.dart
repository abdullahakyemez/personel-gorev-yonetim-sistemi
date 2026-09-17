import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Widget _slot({required Widget child}) {
    return SizedBox(
      height: 72,
      child: Align(
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
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
    final startDate = ref.watch(leaveStartDateFilterProvider);
    final endDate = ref.watch(leaveEndDateFilterProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _slot(
            child: PGYSTextField(
              label: 'Ara',
              hintText: 'Personel, sicil veya açıklama...',
              prefixIcon: const Icon(Icons.search),
              controller: _searchController,
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref.read(leaveSearchProvider.notifier).state = '';
                      },
                    )
                  : null,
              onChanged: (value) {
                ref.read(leaveSearchProvider.notifier).state = value;
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _slot(
            child: PGYSDropdownField<LeaveType>(
              label: 'İzin Türü',
              hint: 'Tümü',
              value: selectedLeaveType,
              items: LeaveType.values,
              labelBuilder: (type) {
                switch (type) {
                  case LeaveType.annual:
                    return 'Yıllık';
                  case LeaveType.excuse:
                    return 'Mazeret';
                  case LeaveType.report:
                    return 'Rapor';
                }
              },
              onChanged: (value) {
                ref.read(selectedLeaveTypeProvider.notifier).state = value;
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: personnelAsync.when(
            data: (personnelList) => _slot(
              child: PGYSDropdownField<int>(
                label: 'Personel',
                hint: 'Tüm Personeller',
                value: selectedPersonnel,
                items: personnelList
                    .where((person) => person.id != null)
                    .map((person) => person.id!)
                    .toList(),
                labelBuilder: (id) {
                  final person = personnelList.firstWhere(
                    (person) => person.id == id,
                  );
                  return person.fullName;
                },
                onChanged: (value) {
                  ref.read(selectedLeavePersonnelProvider.notifier).state = value;
                },
              ),
            ),
            loading: () => const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => _slot(
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Personeller yüklenemedi'),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _slot(
            child: PGYSTextField(
              label: 'Başlangıç Tarihi',
              readOnly: true,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              controller: TextEditingController(text: _formatDate(startDate)),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (selected == null) return;
                ref.read(leaveStartDateFilterProvider.notifier).state = selected;
                if (endDate != null && endDate.isBefore(selected)) {
                  ref.read(leaveEndDateFilterProvider.notifier).state = null;
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _slot(
            child: PGYSTextField(
              label: 'Bitiş Tarihi',
              readOnly: true,
              prefixIcon: const Icon(Icons.event_outlined),
              controller: TextEditingController(text: _formatDate(endDate)),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? startDate ?? DateTime.now(),
                  firstDate: startDate ?? DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (selected == null) return;
                ref.read(leaveEndDateFilterProvider.notifier).state = selected;
              },
            ),
          ),
        ),
      ],
    );
  }
}
