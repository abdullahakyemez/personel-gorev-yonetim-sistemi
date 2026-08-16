import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

class ReportDateFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final VoidCallback onClear;

  const ReportDateFilter({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onClear,
  });

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PGYSTextField(
            label: 'Başlangıç Tarihi',
            hintText: 'Başlangıç tarihi',
            readOnly: true,
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            controller: TextEditingController(text: _formatDate(startDate)),
            onTap: onStartDateTap,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: PGYSTextField(
            label: 'Bitiş Tarihi',
            hintText: 'Bitiş tarihi',
            readOnly: true,
            prefixIcon: const Icon(Icons.event_outlined),
            controller: TextEditingController(text: _formatDate(endDate)),
            onTap: onEndDateTap,
          ),
        ),

        const SizedBox(width: 12),

        IconButton(
          tooltip: 'Filtreleri Temizle',
          onPressed: onClear,
          icon: const Icon(Icons.filter_alt_off),
        ),
      ],
    );
  }
}
