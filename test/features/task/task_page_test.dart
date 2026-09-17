import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/task_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_detail_panel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/widgets/task_filter_bar.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  group('TaskPage Widget Tests', () {
    final testPersonnel = Personnel(
      id: 1,
      registryNumber: 'SICIL001',
      fullName: 'Ahmet Yılmaz',
      rank: 'Uzman',
      title: 'Yazılımcı',
      branch: 'Yazılım',
      department: 'IT',
      startDate: DateTime(2020, 1, 1),
      phone: '05551112233',
      email: 'ahmet@example.com',
      address: 'Ankara',
      status: PersonnelStatus.duty,
    );

    final now = DateTime.now();
    final testTask = Task(
      id: 'task-1',
      personnelIds: [1],
      title: 'Sistem Bakımı',
      description: 'Sunucu güncellemeleri yapılacak',
      status: TaskStatus.inProgress,
      startDate: now,
      endDate: now.add(const Duration(days: 3)),
    );

    Widget createWidgetUnderTest({
      List<Task>? tasks,
      List<Personnel>? personnel,
      String? initialSelectedTaskId,
    }) {
      return ProviderScope(
        overrides: [
          currentPermissionsProvider.overrideWith((ref) => AppPermission.values.toSet()),
          personnelListProvider.overrideWith(
            (ref) async => personnel ?? [testPersonnel],
          ),
          taskControllerProvider.overrideWith(
            () => _MockTaskController(tasks ?? []),
          ),
          if (initialSelectedTaskId != null)
            selectedTaskIdProvider.overrideWith((ref) => initialSelectedTaskId),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskPage(),
          ),
        ),
      );
    }

    testWidgets('renders page header and action buttons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(tasks: []));
      await tester.pumpAndSettle();

      expect(find.text('Görevler'), findsOneWidget);
      expect(find.byTooltip('Filtreleri Temizle'), findsOneWidget);
      expect(find.text('Yeni Görev'), findsOneWidget);
      expect(find.byType(TaskFilterBar), findsOneWidget);
    });

    testWidgets('displays empty state when task list is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(tasks: []));
      await tester.pumpAndSettle();

      expect(find.text('Kayıtlı görev bulunmuyor.'), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
    });

    testWidgets('displays tasks list when data is available', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(tasks: [testTask]));
      await tester.pumpAndSettle();

      expect(find.text('1 görev bulundu'), findsOneWidget);
      expect(find.text('Sistem Bakımı'), findsOneWidget);
    });

    testWidgets('shows TaskDetailPanel when a task is selected and displays ActionChip', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(createWidgetUnderTest(
        tasks: [testTask],
        initialSelectedTaskId: 'task-1',
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetailPanel), findsOneWidget);
      expect(find.text('Görev Detayı'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TaskDetailPanel),
          matching: find.text('Sunucu güncellemeleri yapılacak'),
        ),
        findsOneWidget,
      );

      expect(find.byType(ActionChip), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsWidgets);

      final closeButton = find.byTooltip('Detayı kapat');
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.text('Görev Detayı'), findsNothing);
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
