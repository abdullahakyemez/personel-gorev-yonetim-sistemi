import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/domain/models/personnel_detail_report_statistics.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

class PersonnelDetailReportSection extends StatelessWidget {
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

  String _taskStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.waiting:
        return 'Bekleyen';
      case TaskStatus.inProgress:
        return 'Aktif';
      case TaskStatus.completed:
        return 'Tamamlanan';
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
  Widget build(BuildContext context) {
    final person = report.personnel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonnelInformation(context, person),
        const SizedBox(height: 16),
        _buildTaskStatistics(context),
        const SizedBox(height: 16),
        _buildLeaveStatistics(context),
        const SizedBox(height: 16),
        _buildTaskList(context),
        const SizedBox(height: 16),
        _buildLeaveList(context),
        const SizedBox(height: 16),
        _buildReportList(context),
      ],
    );
  }

  Widget _buildPersonnelInformation(BuildContext context, Personnel person) {
    final statusColor = _statusColor(context, report.currentStatus);

    return _ReportCard(
      title: 'Personel Bilgileri',
      icon: Icons.person_outline,
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
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
          _StatisticBox(title: 'Toplam', value: report.totalTasks),
          _StatisticBox(title: 'Tamamlanan', value: report.completedTasks),
          _StatisticBox(title: 'Devam Eden', value: report.inProgressTasks),
          _StatisticBox(title: 'Bekleyen', value: report.waitingTasks),
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
                  trailing: Text(_taskStatusText(task.status)),
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
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
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
          const SizedBox(height: 4),
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
