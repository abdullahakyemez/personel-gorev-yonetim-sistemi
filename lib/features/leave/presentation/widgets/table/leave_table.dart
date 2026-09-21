import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/table/leave_table_row.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class LeaveTable extends ConsumerWidget {
  final List<Leave> leaves;
  final ValueChanged<Leave>? onSelected;

  const LeaveTable({
    super.key,
    required this.leaves,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedId = ref.watch(selectedLeaveIdProvider);

    if (leaves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 64,
              color: theme.colorScheme.outline.withAlpha(128),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Kayıtlı izin bulunmuyor.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return PGYSCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const minTableWidth = 900.0;
          final needsScroll = constraints.maxWidth < minTableWidth;

          final tableContent = Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Builder(
                  builder: (context) {
                    final headerColor = theme.brightness == Brightness.dark
                        ? theme.colorScheme.onSurface
                        : const Color(0xFF223E47);
                    return Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            'KAYIT NO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'PERSONEL BİLGİSİ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 115,
                          child: Text(
                            'İZİN / RAPOR TÜRÜ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'TARİH ARALIĞI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 65,
                          child: Text(
                            'GÜN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'İKAMETGAH / ADRES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 165,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'İŞLEMLER',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: headerColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Rows
              Expanded(
                child: ListView.builder(
                  itemCount: leaves.length,
                  itemBuilder: (context, index) {
                    final leave = leaves[index];
                    return LeaveTableRow(
                      leave: leave,
                      isSelected: leave.id == selectedId,
                      onTap: () {
                        ref.read(selectedLeaveIdProvider.notifier).state = leave.id;
                        onSelected?.call(leave);
                      },
                    );
                  },
                ),
              ),
            ],
          );

          if (needsScroll) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: minTableWidth,
                child: tableContent,
              ),
            );
          }

          return tableContent;
        },
      ),
    );
  }
}
