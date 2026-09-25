import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_info_tile.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_information_section.dart';

class GeneralInformationTab extends ConsumerWidget {
  final Personnel person;

  const GeneralInformationTab({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entitlement = ref.watch(personnelLeaveEntitlementProvider(person));
    final schedule = person.workSchedule;
    final scheduleLabel = schedule != null
        ? schedule.label
        : '5 Çalışma + 2 İstirahat (Hafta Sonu - 5+2)';
    final cycleDetail = schedule != null
        ? '${schedule.dutyDays} Gün Görev / ${schedule.restDays} Gün İstirahat'
        : '5 Gün Görev / 2 Gün İstirahat';
    final cycleStart = schedule != null
        ? DateFormatter.iso(schedule.startDate)
        : '2026-01-05';
    final startDateStr = DateFormatter.iso(person.startDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entitlement != null) ...[
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'İZİN HAK EDİŞ VE BAKİYE DURUMU (${DateTime.now().year} YILI)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700 ? 4 : 2;
              final width =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: _buildEntitlementCard(
                      context: context,
                      title: 'Yıllık Hak Ediş',
                      value: '${entitlement.baseAnnualQuota} Gün',
                      subtitle: '(${entitlement.seniorityYears} yıl kıdem)',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildEntitlementCard(
                      context: context,
                      title: 'Devreden İzin',
                      value: '${entitlement.transferredDays} Gün',
                      subtitle: 'Önceki yıldan (T-1)',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildEntitlementCard(
                      context: context,
                      title: 'Kullanılan Yıllık',
                      value: '${entitlement.usedAnnualDays} Gün',
                      subtitle:
                          'Mazeret: ${entitlement.usedExcuseDays}g | Rapor: ${entitlement.usedReportDays}g',
                      valueColor: const Color(0xFFD32F2F),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildEntitlementCard(
                      context: context,
                      title: 'Kalan Yıllık İzin',
                      value: '${entitlement.remainingAnnualDays} Gün',
                      subtitle: 'Toplam kota: ${entitlement.totalAnnualDays}g',
                      isHighlighted: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'ÇALIŞMA TAKVİMİ VE NÖBET DÜZENİ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Çalışma Şekli:',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scheduleLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Döngü Detayı:',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cycleDetail,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Döngü Başlangıç Tarihi:',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cycleStart,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Göreve Başlama:',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          startDateStr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PersonnelInformationSection(
                  title: "Kimlik Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.badge_outlined,
                      title: "Sicil",
                      value: person.registryNumber,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.person_outlined,
                      title: "Ad Soyad",
                      value: person.fullName,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.star_border_rounded,
                      title: "Rütbe",
                      value: person.rank,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.online_prediction_rounded,
                      title: "Durum",
                      value: person.status == PersonnelStatus.duty
                          ? "Görevde"
                          : "Görevde değil",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PersonnelInformationSection(
                  title: "Kurum Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.account_tree_outlined,
                      title: "Şube",
                      value: person.department,
                    ),

                    PersonnelInfoTile(
                      icon: Icons.business_outlined,
                      title: "Büro",
                      value: person.branch,
                    ),

                    PersonnelInfoTile(
                      icon: Icons.badge_outlined,
                      title: "Göreve Başlama",
                      value: DateFormatter.short(person.startDate),
                    ),
                    PersonnelInfoTile(
                      icon: Icons.calendar_month_rounded,
                      title: "Büroya Başlama",
                      value: person.officeStartDate == null
                          ? "-"
                          : DateFormatter.short(person.officeStartDate!),
                    ),
                    PersonnelInfoTile(
                      icon: Icons.work_off_outlined,
                      title: "Bürodan Ayrılma",
                      value: person.endDate == null
                          ? "-"
                          : DateFormatter.short(person.endDate!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        if (person.workSchedule != null)
          PersonnelInformationSection(
            title: "Çalışma Düzeni",
            children: [
              PersonnelInfoTile(
                icon: Icons.schedule_outlined,
                title: "Düzen",
                value: person.workSchedule!.label,
              ),
              PersonnelInfoTile(
                icon: Icons.work_outline,
                title: "Görev Günleri",
                value: '${person.workSchedule!.dutyDays} gün',
              ),
              PersonnelInfoTile(
                icon: Icons.hotel_outlined,
                title: "İstirahat Günleri",
                value: '${person.workSchedule!.restDays} gün',
              ),
              PersonnelInfoTile(
                icon: Icons.calendar_today_outlined,
                title: "Döngü Başlangıcı",
                value: DateFormatter.short(person.workSchedule!.startDate),
              ),
            ],
          ),

        const SizedBox(height: AppSpacing.md),
        //const SizedBox(height: 20),
        //const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PersonnelInformationSection(
                  title: "İletişim Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.phone,
                      title: "Telefon",
                      value: person.phone,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.mail_outlined,
                      title: "Email",
                      value: person.email,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.location_on_outlined,
                      title: "Adres",
                      value: person.address,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PersonnelInformationSection(
                  title: "Ek Bilgiler",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.bloodtype_rounded,
                      title: "Kan Grubu",
                      value: person.bloodType != null
                          ? person.bloodType.toString()
                          : "-",
                    ),
                    PersonnelInfoTile(
                      icon: Icons.family_restroom_rounded,
                      title: "Yakını",
                      value: person.relativeName != null
                          ? person.relativeName.toString()
                          : "-",
                    ),
                    PersonnelInfoTile(
                      icon: Icons.phone,
                      title: "Yakın Telefonu",
                      value: person.relativePhone != null
                          ? person.relativePhone.toString()
                          : "-",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEntitlementCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    Color? valueColor,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isHighlighted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13382B) : const Color(0xFFE8F8F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF267355) : const Color(0xFFA3E7C5),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00875A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF00875A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF00875A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
