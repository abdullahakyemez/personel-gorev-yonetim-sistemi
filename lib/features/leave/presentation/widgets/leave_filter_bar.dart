import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_dropdown_field.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

import '../../application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

class LeaveFilterBar extends ConsumerWidget {
  const LeaveFilterBar({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnelAsync = ref.watch(personnelListProvider);

    final selectedLeaveType = ref.watch(selectedLeaveTypeProvider);
    final selectedPersonnel = ref.watch(selectedLeavePersonnelProvider);

    final startDate = ref.watch(leaveStartDateFilterProvider);
    final endDate = ref.watch(leaveEndDateFilterProvider);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PGYSTextField(
            label: 'Ara',
            hintText: 'Personel, sicil veya açıklama...',
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) {
              ref.read(leaveSearchProvider.notifier).state = value;
            },
          ),
        ),

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // İZİN TÜRÜ
        // ----------------------------------------------------------
        Expanded(
          child: PGYSDropdownField<LeaveType>(
            label: 'İzin Türü',
            hint: 'Tümü',

            // ÖNEMLİ:
            // Provider'daki seçili değeri widget'a veriyoruz.
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

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // PERSONEL
        // ----------------------------------------------------------
        Expanded(
          child: personnelAsync.when(
            data: (personnelList) {
              return PGYSDropdownField<String>(
                label: 'Personel',
                hint: 'Tüm Personeller',

                // ÖNEMLİ:
                value: selectedPersonnel,

                items: personnelList
                    .map((person) => person.registryNumber)
                    .toList(),

                labelBuilder: (registryNumber) {
                  final person = personnelList.firstWhere(
                    (person) => person.registryNumber == registryNumber,
                  );

                  return person.fullName;
                },

                onChanged: (value) {
                  ref.read(selectedLeavePersonnelProvider.notifier).state =
                      value;
                },
              );
            },

            loading: () => const Center(child: CircularProgressIndicator()),

            error: (_, _) => const Text('Personeller yüklenemedi'),
          ),
        ),

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // BAŞLANGIÇ TARİHİ
        // ----------------------------------------------------------
        Expanded(
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

              if (selected == null) {
                return;
              }

              ref.read(leaveStartDateFilterProvider.notifier).state = selected;

              // Başlangıç tarihi bitiş tarihinden sonraya seçildiyse
              // mevcut bitiş tarihini de temizliyoruz.
              if (endDate != null && endDate.isBefore(selected)) {
                ref.read(leaveEndDateFilterProvider.notifier).state = null;
              }
            },
          ),
        ),

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // BİTİŞ TARİHİ
        // ----------------------------------------------------------
        Expanded(
          child: PGYSTextField(
            label: 'Bitiş Tarihi',
            readOnly: true,
            prefixIcon: const Icon(Icons.event_outlined),

            controller: TextEditingController(text: _formatDate(endDate)),

            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: endDate ?? startDate ?? DateTime.now(),

                // Başlangıç tarihi varsa bitiş onun öncesine seçilemez.
                firstDate: startDate ?? DateTime(1950),

                lastDate: DateTime(2100),
              );

              if (selected == null) {
                return;
              }

              ref.read(leaveEndDateFilterProvider.notifier).state = selected;
            },
          ),
        ),

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // FİLTRELERİ TEMİZLE
        // ----------------------------------------------------------
      ],
    );
  }
}
