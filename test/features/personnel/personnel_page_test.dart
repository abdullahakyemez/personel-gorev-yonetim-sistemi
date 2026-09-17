import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/selected_personnel_tab_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/pages/personnel_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/table/personnel_list_table.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('PersonnelPage Widget Tests', () {
    final testPersonnel1 = Personnel(
      id: 1,
      registryNumber: 'SICIL001',
      fullName: 'Ahmet Yılmaz',
      rank: 'Uzman',
      title: 'Mühendis',
      branch: 'Yazılım',
      department: 'IT',
      startDate: DateTime(2020, 1, 1),
      phone: '05551112233',
      email: 'ahmet@example.com',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    final testPersonnel2 = Personnel(
      id: 2,
      registryNumber: 'SICIL002',
      fullName: 'Mehmet Demir',
      rank: 'Tekniker',
      title: 'Teknisyen',
      branch: 'Destek',
      department: 'Donanım',
      startDate: DateTime(2021, 6, 1),
      phone: '05552223344',
      email: 'mehmet@example.com',
      address: 'İstanbul',
      status: PersonnelStatus.leave,
    );

    Widget createWidgetUnderTest({
      List<Personnel>? personnel,
      int? initialSelectedPersonnelId,
      PersonnelDetailTab? initialTab,
    }) {
      return ProviderScope(
        overrides: [
          personnelListProvider.overrideWith(
            (ref) async => personnel ?? [testPersonnel1, testPersonnel2],
          ),
          taskControllerProvider.overrideWith(
            () => _MockTaskController([]),
          ),
          leaveControllerProvider.overrideWith(
            () => _MockLeaveController([]),
          ),
          personnelHistoryProvider.overrideWith(
            (ref, id) async => <PersonnelHistory>[],
          ),
          if (initialSelectedPersonnelId != null)
            selectedPersonnelIdProvider
                .overrideWith((ref) => initialSelectedPersonnelId),
          if (initialTab != null)
            selectedPersonnelTabProvider.overrideWith((ref) => initialTab),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: PersonnelPage(),
          ),
        ),
      );
    }

    testWidgets('renders PersonnelPage with header and table', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Personeller'), findsOneWidget);
      expect(find.text('Personel Yönetim Ekranı'), findsOneWidget);

      expect(find.byType(PersonnelTable), findsOneWidget);
      expect(find.byType(MasterDetailLayout), findsOneWidget);

      expect(find.text('Ahmet Yılmaz'), findsOneWidget);
      expect(find.text('Mehmet Demir'), findsOneWidget);
    });

    testWidgets('shows detail panel when a personnel is selected',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(
        initialSelectedPersonnelId: 1,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(PersonnelDetailPanel), findsOneWidget);

      expect(find.text('Genel Bilgiler'), findsOneWidget);
      expect(find.text('Görevler'), findsOneWidget);
      expect(find.text('İzinler'), findsOneWidget);
      expect(find.text('Hareketler'), findsOneWidget);

      expect(find.text('SICIL001'), findsWidgets);
    });

    testWidgets('switching tabs updates content in detail panel',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(
        initialSelectedPersonnelId: 1,
      ));
      await tester.pumpAndSettle();

      // Tap on 'Görevler' tab
      await tester.tap(find.text('Görevler'));
      await tester.pumpAndSettle();

      expect(find.text('Bu personele atanmış görev bulunmuyor.'), findsOneWidget);

      // Tap on 'İzinler' tab
      await tester.tap(find.text('İzinler'));
      await tester.pumpAndSettle();

      expect(find.text('Bu personele ait izin kaydı bulunmuyor.'), findsOneWidget);
    });
  });
}

class _MockTaskController extends AsyncNotifier<List<Task>>
    implements TaskController {
  final List<Task> initialList;
  _MockTaskController(this.initialList);

  @override
  Future<List<Task>> build() async => initialList;

  @override
  Future<void> addTask(Task task) async {}

  @override
  Future<void> updateTask(Task task) async {}

  @override
  Future<void> deleteTask(String id) async {}
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
