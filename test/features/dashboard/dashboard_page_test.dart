import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_recent_activity_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/application/dashboard_upcoming_tasks_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/dashboard_stats_grid.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/recent_activity_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/today_roster_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/widgets/upcoming_tasks_card.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('DashboardPage and Widgets Integration Tests', () {
    Widget createWidgetUnderTest({
      List<Personnel>? personnel,
      List<Leave>? leaves,
      List<Task>? tasks,
    }) {
      return ProviderScope(
        overrides: [
          personnelListProvider.overrideWith(
            (ref) async => personnel ?? [],
          ),
          leaveControllerProvider.overrideWith(
            () => _MockLeaveController(leaves ?? []),
          ),
          taskControllerProvider.overrideWith(
            () => _MockTaskController(tasks ?? []),
          ),
          dashboardRecentActivityProvider.overrideWith(
            (ref) => const AsyncValue.data([]),
          ),
          upcomingTasksProvider.overrideWith(
            (ref) => const AsyncValue.data([]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DashboardPage(),
          ),
        ),
      );
    }

    testWidgets('renders all major dashboard components and headers',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardStatsGrid), findsOneWidget);
      expect(find.byType(TodayRosterCard), findsOneWidget);
      expect(find.byType(RecentActivityCard), findsOneWidget);
      expect(find.byType(UpcomingTaskCard), findsOneWidget);
    });

    testWidgets('renders TodayRosterCard with 4 status categories',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      final testPersonnel = [
        Personnel(
          id: 1,
          registryNumber: 'SICIL001',
          fullName: 'Ali Kaya',
          rank: 'Mühendis',
          title: 'Yazılımcı',
          branch: 'AR-GE',
          department: 'IT',
          startDate: DateTime(2020, 1, 1),
          phone: '05551234567',
          email: 'ali@example.com',
          address: 'Ankara',
          status: PersonnelStatus.duty,
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest(personnel: testPersonnel));
      await tester.pumpAndSettle();

      expect(find.text('Görevde'), findsWidgets);
      expect(find.text('İstirahatli'), findsWidgets);
      expect(find.text('İzinli'), findsWidgets);
      expect(find.text('Raporlu'), findsWidgets);

      expect(find.text('Ali Kaya'), findsOneWidget);
      expect(find.text('Mühendis'), findsOneWidget);
    });

    testWidgets('shows empty state messages when activities and tasks are empty',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Henüz görev aktivitesi bulunmuyor'), findsOneWidget);
      expect(find.text('Yaklaşan görev bulunmuyor'), findsOneWidget);
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
