import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_document_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/export/leave_excel_export_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/extensions/leave_type_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/dialogs/leave_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';

class LeaveTableRow extends ConsumerWidget {
  final Leave leave;
  final bool isSelected;
  final VoidCallback? onTap;

  const LeaveTableRow({
    super.key,
    required this.leave,
    required this.isSelected,
    this.onTap,
  });

  Color _typeBgColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return const Color(0xFFFFF8E1);
      case LeaveType.report:
        return const Color(0xFFFFEBEE);
      case LeaveType.excuse:
        return const Color(0xFFE1F5FE);
    }
  }

  Color _typeBorderColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return const Color(0xFFFFE082);
      case LeaveType.report:
        return const Color(0xFFFFCDD2);
      case LeaveType.excuse:
        return const Color(0xFF81D4FA);
    }
  }

  Color _typeTextColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return const Color(0xFFD97706);
      case LeaveType.report:
        return const Color(0xFFC62828);
      case LeaveType.excuse:
        return const Color(0xFF0288D1);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final personnelAsync = ref.watch(personnelListProvider);
    final canEditLeave = ref.watch(hasPermissionProvider(AppPermission.editLeave));
    final canDeleteLeave = ref.watch(hasPermissionProvider(AppPermission.deleteLeave));

    final person = personnelAsync.value?.cast().firstWhere(
          (p) => p.id == leave.personnelId,
          orElse: () => null,
        );

    final recordNo = LeaveExcelExportService.formatLeaveRecordNo(leave);

    return InkWell(
      onTap: onTap,
      hoverColor: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 1. KAYIT NO
            SizedBox(
              width: 120,
              child: Text(
                recordNo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. PERSONEL BİLGİSİ
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    person?.fullName ?? 'Personel #${leave.personnelId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${person?.rank ?? "Memur"} • Sicil: ${person?.registryNumber ?? "-"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 3. İZİN / RAPOR TÜRÜ
            SizedBox(
              width: 115,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _typeBgColor(leave.type),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _typeBorderColor(leave.type)),
                  ),
                  child: Text(
                    leave.type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _typeTextColor(leave.type),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 4. TARİH ARALIĞI
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (leave.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      leave.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 5. GÜN
            SizedBox(
              width: 65,
              child: Text(
                '${leave.dayCount} Gün',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 6. İKAMETGAH / ADRES
            Expanded(
              flex: 2,
              child: Text(
                person?.address ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 7. İŞLEMLER
            SizedBox(
              width: 165,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Belge butonu
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      if (person == null) {
                        PGYSFeedback.showWarning(context, 'Personel bilgisi bulunamadı.');
                        return;
                      }
                      await LeaveDocumentService().exportLeaveDocument(
                        leave: leave,
                        person: person,
                      );
                      if (context.mounted) {
                        PGYSFeedback.showSuccess(
                          context,
                          '${person.fullName} için izin dilekçesi/belgesi oluşturuldu.',
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.print_outlined,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Belge',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (canEditLeave)
                    Tooltip(
                      message: 'Düzenle',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await showLeaveDialog(context, leave: leave);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 17,
                            color: Color(0xFF1E5F74),
                          ),
                        ),
                      ),
                    ),
                  if (canDeleteLeave)
                    Tooltip(
                      message: 'Sil',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final confirmed = await showPGYSConfirmDialog(
                            context: context,
                            title: 'İzni Sil',
                            message: 'Bu izin kaydını silmek istediğinize emin misiniz?',
                            confirmText: 'Sil',
                            cancelText: 'Vazgeç',
                            isDestructive: true,
                          );

                          if (confirmed == true) {
                            await ref
                                .read(leaveControllerProvider.notifier)
                                .deleteLeave(leave.id);
                            if (ref.read(selectedLeaveIdProvider) == leave.id) {
                              ref.read(selectedLeaveIdProvider.notifier).state = null;
                            }
                            if (context.mounted) {
                              PGYSFeedback.showSuccess(
                                context,
                                'İzin kaydı başarıyla silindi.',
                              );
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                            color: Color(0xFFE53935),
                          ),
                        ),
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
