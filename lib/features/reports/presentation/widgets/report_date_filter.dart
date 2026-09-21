import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/forms/pgys_text_field.dart';

class ReportDateFilter extends StatefulWidget {
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

  @override
  State<ReportDateFilter> createState() => _ReportDateFilterState();
}

class _ReportDateFilterState extends State<ReportDateFilter> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: _formatDate(widget.startDate));
    _endController = TextEditingController(text: _formatDate(widget.endDate));
  }

  @override
  void didUpdateWidget(covariant ReportDateFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate) {
      _startController.text = _formatDate(widget.startDate);
    }
    if (oldWidget.endDate != widget.endDate) {
      _endController.text = _formatDate(widget.endDate);
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
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
            controller: _startController,
            onTap: widget.onStartDateTap,
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: PGYSTextField(
            label: 'Bitiş Tarihi',
            hintText: 'Bitiş tarihi',
            readOnly: true,
            prefixIcon: const Icon(Icons.event_outlined),
            controller: _endController,
            onTap: widget.onEndDateTap,
          ),
        ),

        const SizedBox(width: 12),

        IconButton(
          tooltip: 'Filtreleri Temizle',
          onPressed: widget.onClear,
          icon: const Icon(Icons.filter_alt_off),
        ),
      ],
    );
  }
}
