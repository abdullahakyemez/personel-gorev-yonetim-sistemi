import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/personnel_report_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/report_pdf_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/application/reports_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/domain/models/personnel_detail_report_statistics.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';

class PersonnelDetailReportSection extends ConsumerWidget {
  final PersonnelDetailReportStatistics report;

  const PersonnelDetailReportSection({super.key, required this.report});

  String _statusText(PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return 'Görevde';
      case PersonnelStatus.resting:
        return 'İstirahatli';
      case PersonnelStatus.leave:
        return 'İzinli';
      case PersonnelStatus.sickReport:
        return 'Raporlu';
    }
  }

  String _leaveTypeText(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Yıllık İzin';
      case LeaveType.excuse:
        return 'Mazeret İzni';
      case LeaveType.report:
        return 'Rapor';
    }
  }

  Color _statusColor(BuildContext context, PersonnelStatus status) {
    switch (status) {
      case PersonnelStatus.duty:
        return Colors.green;
      case PersonnelStatus.resting:
        return Colors.orange;
      case PersonnelStatus.leave:
        return Colors.blue;
      case PersonnelStatus.sickReport:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = report.personnel;
    final startDate = ref.watch(reportStartDateProvider);
    final endDate = ref.watch(reportEndDateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonnelHeader(context, ref, person, startDate, endDate),
        const SizedBox(height: AppSpacing.md),
        _buildPersonnelInformation(context, person),
        const SizedBox(height: AppSpacing.md),
        _buildTaskStatistics(context),
        const SizedBox(height: AppSpacing.md),
        _buildLeaveStatistics(context),
        const SizedBox(height: AppSpacing.md),
        _buildTaskList(context),
        const SizedBox(height: AppSpacing.md),
        _buildLeaveList(context),
        const SizedBox(height: AppSpacing.md),
        _buildReportList(context),
      ],
    );
  }

  Widget _buildPersonnelHeader(
    BuildContext context,
    WidgetRef ref,
    Personnel person,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${person.registryNumber} - ${person.fullName}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _PersonnelDetailExportButtons(
          person: person,
          startDate: startDate,
          endDate: endDate,
        ),
      ],
    );
  }

  Widget _buildPersonnelInformation(BuildContext context, Personnel person) {
    final statusColor = _statusColor(context, report.currentStatus);

    return _ReportCard(
      title: 'Personel Bilgileri',
      icon: Icons.person_outline,
      child: Wrap(
        spacing: AppSpacing.xl,
        runSpacing: AppSpacing.md,
        children: [
          _InfoItem(title: 'Ad Soyad', value: person.fullName),
          _InfoItem(title: 'Sicil', value: person.registryNumber),
          _InfoItem(title: 'Rütbe', value: person.rank),
          _InfoItem(title: 'Şube', value: person.department),
          _InfoItem(title: 'Büro', value: person.branch),
          _InfoItem(
            title: 'Çalışma Düzeni',
            value: person.workSchedule?.label ?? '-',
          ),
          _InfoItem(
            title: 'Güncel Durum',
            value: _statusText(report.currentStatus),
            valueColor: statusColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatistics(BuildContext context) {
    return _ReportCard(
      title: 'Görev İstatistikleri',
      icon: Icons.task_alt_outlined,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _StatisticBox(title: 'Toplam Görev', value: report.totalTasks),
          for (final category in TaskCategory.values)
            _StatisticBox(title: category.label, value: report.categoryCounts[category.label] ?? 0),
        ],
      ),
    );
  }

  Widget _buildLeaveStatistics(BuildContext context) {
    return _ReportCard(
      title: 'İzin ve Rapor İstatistikleri',
      icon: Icons.event_available_outlined,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _StatisticBox(
            title: 'Yıllık İzin',
            value: report.annualLeaveDays,
            suffix: 'gün',
          ),
          _StatisticBox(
            title: 'Mazeret İzni',
            value: report.excuseLeaveDays,
            suffix: 'gün',
          ),
          _StatisticBox(
            title: 'Rapor',
            value: report.reportDays,
            suffix: 'gün',
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return _ReportCard(
      title: 'Görevler',
      icon: Icons.assignment_outlined,
      child: report.tasks.isEmpty
          ? const _EmptyText(text: 'Bu personele ait görev bulunmuyor.')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.tasks.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final task = report.tasks[index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(task.title),
                  subtitle: Text(
                    '${DateFormatter.short(task.startDate)} - '
                    '${DateFormatter.short(task.endDate)}',
                  ),
                  trailing: Text(task.status.label),
                );
              },
            ),
    );
  }

  Widget _buildLeaveList(BuildContext context) {
    return _ReportCard(
      title: 'İzinler',
      icon: Icons.beach_access_outlined,
      child: report.leaves.isEmpty
          ? const _EmptyText(text: 'İzin kaydı bulunmuyor.')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.leaves.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final leave = report.leaves[index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_leaveTypeText(leave.type)),
                  subtitle: Text(
                    '${DateFormatter.short(leave.startDate)} - '
                    '${DateFormatter.short(leave.endDate)}',
                  ),
                  trailing: Text('${leave.dayCount} gün'),
                );
              },
            ),
    );
  }

  Widget _buildReportList(BuildContext context) {
    return _ReportCard(
      title: 'Raporlar',
      icon: Icons.medical_information_outlined,
      child: report.reports.isEmpty
          ? const _EmptyText(text: 'Rapor kaydı bulunmuyor.')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.reports.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final leave = report.reports[index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${DateFormatter.short(leave.startDate)} - '
                    '${DateFormatter.short(leave.endDate)}',
                  ),
                  subtitle: Text(
                    leave.description.isEmpty
                        ? 'Açıklama yok'
                        : leave.description,
                  ),
                  trailing: Text('${leave.dayCount} gün'),
                );
              },
            ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ReportCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatisticBox extends StatelessWidget {
  final String title;
  final int value;
  final String? suffix;

  const _StatisticBox({required this.title, required this.value, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            suffix == null ? '$value' : '$value $suffix',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoItem({required this.title, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}

class _PersonnelDetailExportButtons extends ConsumerStatefulWidget {
  final Personnel person;
  final DateTime? startDate;
  final DateTime? endDate;

  const _PersonnelDetailExportButtons({
    required this.person,
    required this.startDate,
    required this.endDate,
  });

  @override
  ConsumerState<_PersonnelDetailExportButtons> createState() =>
      _PersonnelDetailExportButtonsState();
}

class _PersonnelDetailExportButtonsState
    extends ConsumerState<_PersonnelDetailExportButtons> {
  bool _isExportingPdf = false;
  bool _isExportingExcel = false;

  @override
  Widget build(BuildContext context) {
    final hasValidRange = widget.startDate != null && widget.endDate != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1E5F74),
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                const Color(0xFF1E5F74).withValues(alpha: 0.4),
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          onPressed: !hasValidRange || _isExportingPdf || _isExportingExcel
              ? null
              : () async {
                  setState(() => _isExportingPdf = true);
                  try {
                    final tasks = ref.read(taskControllerProvider).value ?? [];
                    final leaves =
                        ref.read(leaveControllerProvider).value ?? [];
                    final path =
                        await ReportPdfExportService.exportPersonnelReport(
                          startDate: widget.startDate!,
                          endDate: widget.endDate!,
                          person: widget.person,
                          tasks: tasks,
                          leaves: leaves,
                        );
                    if (!context.mounted || path == null) return;
                    PGYSFeedback.showSuccess(
                      context,
                      'Personel PDF raporu kaydedildi: $path',
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    PGYSFeedback.showError(
                      context,
                      'PDF aktarımı başarısız: $error',
                    );
                  } finally {
                    if (mounted) {
                      setState(() => _isExportingPdf = false);
                    }
                  }
                },
          icon: _isExportingPdf
              ? const SizedBox(
                  width: AppSpacing.md,
                  height: AppSpacing.md,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.picture_as_pdf_outlined, size: 16),
          label: const Text(
            'PDF Aktar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF00875A),
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                const Color(0xFF00875A).withValues(alpha: 0.4),
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          onPressed: !hasValidRange || _isExportingPdf || _isExportingExcel
              ? null
              : () async {
                  setState(() => _isExportingExcel = true);
                  try {
                    final tasks = ref.read(taskControllerProvider).value ?? [];
                    final leaves =
                        ref.read(leaveControllerProvider).value ?? [];
                    final path = await PersonnelReportExportService()
                        .exportExcel(
                          startDate: widget.startDate!,
                          endDate: widget.endDate!,
                          person: widget.person,
                          tasks: tasks,
                          leaves: leaves,
                        );
                    if (!context.mounted || path == null) return;
                    PGYSFeedback.showSuccess(
                      context,
                      'Personel Excel raporu kaydedildi: $path',
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    PGYSFeedback.showError(
                      context,
                      'Excel aktarımı başarısız: $error',
                    );
                  } finally {
                    if (mounted) {
                      setState(() => _isExportingExcel = false);
                    }
                  }
                },
          icon: _isExportingExcel
              ? const SizedBox(
                  width: AppSpacing.md,
                  height: AppSpacing.md,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.table_chart_outlined, size: 16),
          label: const Text(
            'Excel Aktar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
