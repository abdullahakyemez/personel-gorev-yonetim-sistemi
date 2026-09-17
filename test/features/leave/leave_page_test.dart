import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/selected_leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/leave_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/widgets/leave_filter_bar.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('LeavePage Widget Tests', () {
    final testPersonnel = Personnel(
      id: 1,
      registryNumber: 'SICIL002',
      fullName: 'Mehmet Demir',
      rank: 'Memur',
      title: 'Tekniker',
      branch: 'Destek',
      department: 'İdari İşler',
      startDate: DateTime(2021, 5, 1),
      phone: '05559876543',
      email: 'mehmet@example.com',
      address: 'İstanbul',
      status: PersonnelStatus.leave,
    );

    final now = DateTime.now();
    final testLeave = Leave(
      id: 'leave-1',
      personnelId: 1,
      startDate: now,
      endDate: now.add(const Duration(days: 4)),
      type: LeaveType.annual,
      description: 'Yıllık izin kullanımı',
    );

    Widget createWidgetUnderTest({
      List<Leave>? leaves,
      List<Personnel>? personnel,
      String? initialSelectedLeaveId,
    }) {
      return ProviderScope(
        overrides: [
          currentPermissionsProvider.overrideWith((ref) => AppPermission.values.toSet()),
          personnelListProvider.overrideWith(
            (ref) async => personnel ?? [testPersonnel],
          ),
          leaveControllerProvider.overrideWith(
            () => _MockLeaveController(leaves ?? []),
          ),
          if (initialSelectedLeaveId != null)
            selectedLeaveIdProvider.overrideWith((ref) => initialSelectedLeaveId),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: LeavePage(),
          ),
        ),
      );
    }

    testWidgets('renders page header and action buttons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(leaves: []));
      await tester.pumpAndSettle();

      expect(find.text('İzinler'), findsOneWidget);
      expect(find.byTooltip('Filtreleri Temizle'), findsOneWidget);
      expect(find.text('Yeni İzin'), findsOneWidget);
      expect(find.byType(LeaveFilterBar), findsOneWidget);
    });

    testWidgets('displays empty state with icon when leaves list is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(leaves: []));
      await tester.pumpAndSettle();

      expect(find.text('Kayıtlı izin bulunmuyor.'), findsOneWidget);
      expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
    });

    testWidgets('displays leaves list when data is available', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(leaves: [testLeave]));
      await tester.pumpAndSettle();

      expect(find.text('1 izin bulundu'), findsOneWidget);
      expect(find.text('Yıllık İzin'), findsWidgets);
    });

    testWidgets('shows LeaveDetailPanel when a leave is selected and displays ActionChip', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(
        leaves: [testLeave],
        initialSelectedLeaveId: 'leave-1',
      ));
      await tester.pumpAndSettle();

      expect(find.byType(LeaveDetailPanel), findsOneWidget);
      expect(find.text('İzin Detayı'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LeaveDetailPanel),
          matching: find.text('Yıllık izin kullanımı'),
        ),
        findsOneWidget,
      );

      expect(find.byType(ActionChip), findsOneWidget);
      expect(find.text('Mehmet Demir'), findsWidgets);

      final closeButton = find.byTooltip('Detayı kapat');
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.text('İzin Detayı'), findsNothing);
    });
  });
}

class _MockLeaveController extends AsyncNotifier<List<Leave>>
    implements LeaveController {
  final List<Leave> initialList;
  _MockLeaveController(this.initialList);

  @override
  Future<List<Leave>> build() async => initialList;

  @override
  Future<void> addLeave(Leave leave) async {}

  @override
  Future<void> updateLeave(Leave leave) async {}

  @override
  Future<void> deleteLeave(String id) async {}

  @override
  Future<void> refreshLeaves() async {}
}
