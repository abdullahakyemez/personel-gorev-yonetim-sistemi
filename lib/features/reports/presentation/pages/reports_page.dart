import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

import 'package:personel_gorev_yonetim_sistemi/features/reports/application/personnel_detail_report_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/domain/models/report_statistics.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/widgets/personnel_detail_report_section.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/widgets/report_date_filter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/widgets/task_report_section.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_report_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/report_pdf_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

import '../../application/reports_provider.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportStartDate = ref.watch(reportStartDateProvider);
    final reportEndDate = ref.watch(reportEndDateProvider);

    final personnelReportAsync = ref.watch(personnelReportStatisticsProvider);

    final leaveReportAsync = ref.watch(leaveReportStatisticsProvider);

    final personnelAsync = ref.watch(personnelListProvider);

    final detailReportAsync = ref.watch(personnelDetailReportProvider);

    final selectedPersonnelId = ref.watch(selectedReportPersonnelIdProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Raporlar',
            subtitle: 'Personel, izin, görev ve performans raporları',
          ),

          const SizedBox(height: 24),

          // ============================================================
          // TARİH FİLTRESİ
          // ============================================================
          ReportDateFilter(
            startDate: reportStartDate,
            endDate: reportEndDate,
            onStartDateTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: reportStartDate ?? DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
              );

              if (selected == null) {
                return;
              }

              ref.read(reportStartDateProvider.notifier).state = selected;

              final currentEnd = ref.read(reportEndDateProvider);

              if (currentEnd != null && currentEnd.isBefore(selected)) {
                ref.read(reportEndDateProvider.notifier).state = null;
              }
            },
            onEndDateTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: reportEndDate ?? reportStartDate ?? DateTime.now(),
                firstDate: reportStartDate ?? DateTime(1950),
                lastDate: DateTime(2100),
              );

              if (selected == null) {
                return;
              }

              ref.read(reportEndDateProvider.notifier).state = selected;
            },
            onClear: () {
              ref.read(reportStartDateProvider.notifier).state =
                  currentWorkYear.start;
              ref.read(reportEndDateProvider.notifier).state =
                  currentWorkYear.end;
            },
          ),

          const SizedBox(height: 8),
          Text(
            'Rapor dönemi: ${reportStartDate != null && reportEndDate != null ? _formatPeriod(reportStartDate, reportEndDate) : 'Belirlenmedi'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 32),

          // ============================================================
          // 1. PERSONEL RAPORLARI
          // ============================================================
          personnelReportAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => PGYSCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Personel raporu oluşturulamadı.\n$error'),
                    ),
                  ],
                ),
              ),
            ),
            data: (report) => _PersonnelReports(report: report),
          ),

          const SizedBox(height: 32),

          // ============================================================
          // 2. İZİN VE RAPOR RAPORLARI
          // ============================================================
          leaveReportAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => PGYSCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('İzin ve rapor raporu oluşturulamadı.\n$error'),
              ),
            ),
            data: (report) => _LeaveReports(report: report),
          ),

          const SizedBox(height: 32),

          // ============================================================
          // 3. GÖREV RAPORLARI
          // ============================================================
          const TaskReportSection(),

          const SizedBox(height: 32),

          // ============================================================
          // 4. PERSONEL DETAY RAPORU
          // ============================================================
          _buildPersonnelSelector(
            context,
            ref,
            personnelAsync,
            selectedPersonnelId,
          ),

          const SizedBox(height: 16),

          detailReportAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => PGYSCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Personel detay raporu oluşturulurken '
                  'hata oluştu: $error',
                ),
              ),
            ),
            data: (report) {
              if (report == null) {
                return const _ReportEmptyState(
                  icon: Icons.person_search_outlined,
                  message: 'Detaylı rapor görmek için bir personel seçiniz.',
                );
              }

              return PersonnelDetailReportSection(report: report);
            },
          ),
        ],
      ),
    );
  }

  String _formatPeriod(DateTime start, DateTime end) {
    String f(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    return '${f(start)} - ${f(end)}';
  }

  Widget _buildPersonnelSelector(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Personnel>> personnelAsync,
    int? selectedPersonnelId,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_search_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '4. Personel Detay Raporu',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            personnelAsync.when(
              loading: () => const LinearProgressIndicator(),

              error: (error, stackTrace) =>
                  Text('Personel listesi alınamadı: $error'),

              data: (personnelList) {
                if (personnelList.isEmpty) {
                  return const Text('Kayıtlı personel bulunmuyor.');
                }

                return DropdownButtonFormField<int>(
                  initialValue: selectedPersonnelId,
                  decoration: const InputDecoration(
                    labelText: 'Personel',
                    hintText: 'Raporlanacak personeli seçiniz',
                    border: OutlineInputBorder(),
                  ),
                  items: personnelList.map((person) {
                    return DropdownMenuItem<int>(
                      value: person.id,
                      child: Text(
                        '${person.registryNumber} - ${person.fullName}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(selectedReportPersonnelIdProvider.notifier).state =
                        value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// BOŞ RAPOR DURUMU
// ============================================================================

class _ReportEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _ReportEmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                icon,
                size: 42,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 1. PERSONEL RAPORLARI
// ============================================================================

class _PersonnelReports extends StatelessWidget {
  final PersonnelReportStatistics report;

  const _PersonnelReports({required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Personel Raporları',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 16),

        _buildStatusCards(context),

        const SizedBox(height: 24),

        _buildDistributionCard(
          context,
          title: 'Çalışma Düzeni Dağılımı',
          icon: Icons.schedule_outlined,
          data: report.workScheduleDistribution,
        ),

        const SizedBox(height: 16),

        _buildDistributionCard(
          context,
          title: 'Büro Dağılımı',
          icon: Icons.business_outlined,
          data: report.branchDistribution,
        ),

        const SizedBox(height: 16),

        _buildDistributionCard(
          context,
          title: 'Rütbe Dağılımı',
          icon: Icons.military_tech_outlined,
          data: report.rankDistribution,
        ),
      ],
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    final cards = [
      _StatCard(
        title: 'Toplam Personel',
        value: report.totalPersonnel,
        icon: Icons.people_alt_outlined,
      ),
      _StatCard(
        title: 'Görevde',
        value: report.dutyPersonnel,
        icon: Icons.work_outline,
      ),
      _StatCard(
        title: 'İstirahatli',
        value: report.restingPersonnel,
        icon: Icons.hotel_outlined,
      ),
      _StatCard(
        title: 'İzinli',
        value: report.leavePersonnel,
        icon: Icons.beach_access_outlined,
      ),
      _StatCard(
        title: 'Raporlu',
        value: report.sickReportPersonnel,
        icon: Icons.medical_services_outlined,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200
            ? 5
            : constraints.maxWidth >= 800
            ? 3
            : constraints.maxWidth >= 500
            ? 2
            : 1;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 1 ? 2.8 : 2.1,
          children: cards,
        );
      },
    );
  }

  Widget _buildDistributionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Map<String, int> data,
  }) {
    return PGYSCard(
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

            if (data.isEmpty)
              const Text('Veri bulunmuyor.')
            else
              ...data.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry.key)),
                      Text(
                        '${entry.value}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. İZİN VE RAPOR RAPORLARI
// ============================================================================

class _LeaveReports extends ConsumerWidget {
  final LeaveReportStatistics report;

  const _LeaveReports({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedPersonnel = report.personnelLeaveCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. İzin ve Rapor Raporları',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final start = ref.read(reportStartDateProvider);
                final end = ref.read(reportEndDateProvider);
                if (start == null || end == null) return;

                try {
                  final personnel = await ref.read(
                    personnelListProvider.future,
                  );
                  final leaves =
                      ref.read(leaveControllerProvider).value ?? <Leave>[];
                  final path = await ReportPdfExportService.exportLeaveReport(
                    startDate: start,
                    endDate: end,
                    personnel: personnel,
                    leaves: leaves,
                  );
                  if (!context.mounted || path == null) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF raporu kaydedildi: $path')),
                  );
                } catch (error) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF aktarımı başarısız: $error')),
                  );
                }
              },
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Aktar'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final start = ref.read(reportStartDateProvider);
                final end = ref.read(reportEndDateProvider);
                if (start == null || end == null) return;

                try {
                  final personnel = await ref.read(
                    personnelListProvider.future,
                  );
                  final leaves =
                      ref.read(leaveControllerProvider).value ?? <Leave>[];
                  final path = await LeaveReportExportService().exportExcel(
                    startDate: start,
                    endDate: end,
                    personnel: personnel,
                    leaves: leaves,
                  );
                  if (!context.mounted || path == null) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Excel raporu kaydedildi: $path')),
                  );
                } catch (error) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Excel aktarımı başarısız: $error')),
                  );
                }
              },
              icon: const Icon(Icons.table_view_outlined),
              label: const Text('Excel Aktar'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 680
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: columns == 1 ? 2.8 : 2.2,
              children: [
                _StatCard(
                  title: 'Toplam Kayıt',
                  value: report.totalLeaveCount,
                  icon: Icons.event_note_outlined,
                ),
                _StatCard(
                  title: 'Yıllık İzin',
                  value: report.annualLeaveCount,
                  icon: Icons.beach_access_outlined,
                ),
                _StatCard(
                  title: 'Mazeret İzni',
                  value: report.excuseLeaveCount,
                  icon: Icons.event_busy_outlined,
                ),
                _StatCard(
                  title: 'Rapor',
                  value: report.reportCount,
                  icon: Icons.medical_services_outlined,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        const SizedBox(height: 24),

        PGYSCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'En Fazla İzin / Rapor Kaydı Olan Personeller',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (sortedPersonnel.isEmpty)
                  const Text('Henüz izin veya rapor kaydı bulunmuyor.')
                else
                  ...sortedPersonnel
                      .take(10)
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text('Sicil: ${entry.key}')),
                              Text(
                                '${entry.value} kayıt',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// İSTATİSTİK KARTI
// ============================================================================

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$value',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
