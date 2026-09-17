import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_primary_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/buttons/pgys_danger_button.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/services/personnel_status_resolver.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/extensions/personnel_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/dialogs/personnel_dialogs.dart';
//import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_assignment_provider.dart';

class PersonnelProfileCard extends ConsumerWidget {
  final Personnel person;

  const PersonnelProfileCard({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(hasPermissionProvider(AppPermission.editPersonnel));
    final canDelete = ref.watch(hasPermissionProvider(AppPermission.deletePersonnel));
    final leavesAsync = ref.watch(leaveControllerProvider);
    final entitlement = ref.watch(personnelLeaveEntitlementProvider(person));

    final currentStatus = leavesAsync.when(
      data: (leaves) => PersonnelStatusResolver.resolve(
        personnel: person,
        leaves: leaves,
      ),
      loading: () => person.status,
      error: (_, _) => person.status,
    );

    final isDuty = currentStatus == PersonnelStatus.duty;
    final statusText = currentStatus.label;

    return PGYSCard(
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDuty
                    ? Theme.of(context).colorScheme.secondary.withValues(alpha: .12)
                    : Theme.of(context).colorScheme.error.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: isDuty
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.fullName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),

                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              person.rank,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 4),
                            const Text(" / "),
                            const SizedBox(width: 4),
                            Text(
                              person.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.badge_outlined, size: 18),
                              label: Text(person.registryNumber),
                              backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                                alpha: .15,
                              ),
                              side: BorderSide.none,
                            ),

                            Chip(
                              avatar: const Icon(Icons.business_outlined, size: 18),
                              label: Text(person.branch),
                              backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                                alpha: .15,
                              ),
                              side: BorderSide.none,
                            ),

                            Chip(
                              avatar: const Icon(
                                Icons.account_tree_outlined,
                                size: 18,
                              ),
                              label: Text(person.department),
                              backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(
                                alpha: .15,
                              ),
                              side: BorderSide.none,
                            ),
                          ],
                        ),

                        if (canEdit || canDelete) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (canEdit)
                                Expanded(
                                  child: PGYSPrimaryButton(
                                    text: 'Düzenle',
                                    icon: Icons.edit,
                                    onPressed: () {
                                      showEditPersonnelDialog(context, person);
                                    },
                                  ),
                                ),
                              if (canEdit && canDelete) const SizedBox(width: 12),
                              if (canDelete)
                                Expanded(
                                  child: PgysDangerButton(
                                    text: 'Sil',
                                    icon: Icons.delete_outline_rounded,
                                    onPressed: () {
                                      showDeletePersonnelDialog(context, ref, person);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              if (entitlement != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.beach_access_rounded,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: 'İzin Hak Ediş & Bakiye (${DateTime.now().year})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Kıdem: ${entitlement.seniorityYears} Yıl',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entitlement.totalAnnualDays > 0
                              ? entitlement.usagePercentage
                              : 0.0,
                          minHeight: 6,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            entitlement.remainingAnnualDays == 0
                                ? Theme.of(context).colorScheme.error
                                : entitlement.remainingAnnualDays <= 5
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _buildEntitlementMetric(
                            context,
                            label: 'Yıllık Hak',
                            value: '${entitlement.baseAnnualQuota} Gün',
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          if (entitlement.transferredDays > 0) ...[
                            _buildEntitlementMetric(
                              context,
                              label: 'Devreden',
                              value: '${entitlement.transferredDays} Gün',
                              color: Theme.of(context).colorScheme.tertiary,
                              isBold: true,
                            ),
                            _buildEntitlementMetric(
                              context,
                              label: 'Toplam Hak',
                              value: '${entitlement.totalAnnualDays} Gün',
                              color: Theme.of(context).colorScheme.primary,
                              isBold: true,
                            ),
                          ],
                          _buildEntitlementMetric(
                            context,
                            label: 'Kullanılan',
                            value: '${entitlement.usedAnnualDays} Gün',
                            color: Theme.of(context).colorScheme.error,
                          ),
                          _buildEntitlementMetric(
                            context,
                            label: 'Kalan İzin',
                            value: '${entitlement.remainingAnnualDays} Gün',
                            color: entitlement.remainingAnnualDays > 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                            isBold: true,
                          ),
                          _buildEntitlementMetric(
                            context,
                            label: 'Mazeret',
                            value: '${entitlement.usedExcuseDays} Gün',
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          _buildEntitlementMetric(
                            context,
                            label: 'Rapor',
                            value: '${entitlement.usedReportDays} Gün',
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntitlementMetric(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
