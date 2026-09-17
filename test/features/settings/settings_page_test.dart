import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/presentation/pages/settings_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/controllers/task_controller.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart'
    show taskControllerProvider;
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

void main() {
  group('SettingsPage Widget Tests', () {
    final testSettings = AppSettings(
      appName: 'Personel ve Görev Yönetim Sistemi',
      dateFormat: 'dd.MM.yyyy',
      themeMode: AppThemeMode.system,
    );

    final adminUser = AppUser(
      id: 1,
      username: '123456',
      fullName: 'Büro Amiri',
      role: UserRole.admin,
      createdAt: DateTime.now(),
    );

    Widget createWidgetUnderTest({
      AppSettings? settings,
      AppUser? user,
      int personnelCount = 5,
      int taskCount = 3,
      int leaveCount = 2,
    }) {
      return ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => user ?? adminUser),
          settingsProvider.overrideWith(
            () => _MockSettingsNotifier(settings ?? testSettings),
          ),
          personnelListProvider.overrideWith(
            (ref) async => List.generate(
              personnelCount,
              (i) => Personnel(
                id: i + 1,
                registryNumber: 'SICIL00$i',
                fullName: 'Personel $i',
                rank: 'Uzman',
                title: 'Mühendis',
                branch: 'IT',
                department: 'Yazılım',
                startDate: DateTime(2022, 1, 1),
                phone: '0555000000$i',
                email: 'user$i@test.com',
                address: 'Ankara',
                status: PersonnelStatus.duty,
              ),
            ),
          ),
          taskControllerProvider.overrideWith(
            () => _MockTaskController(
              List.generate(
                taskCount,
                (i) => Task(
                  id: 'task-$i',
                  personnelIds: [1],
                  title: 'Görev $i',
                  description: 'Açıklama $i',
                  status: TaskStatus.inProgress,
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 1)),
                ),
              ),
            ),
          ),
          leaveControllerProvider.overrideWith(
            () => _MockLeaveController(
              List.generate(
                leaveCount,
                (i) => Leave(
                  id: 'leave-$i',
                  personnelId: 1,
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 2)),
                  type: LeaveType.annual,
                  description: 'İzin $i',
                ),
              ),
            ),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SettingsPage(),
          ),
        ),
      );
    }

    testWidgets('renders all major settings cards and headers', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Ayarlar'), findsOneWidget);
      expect(find.text('Uygulama ve sistem ayarları'), findsOneWidget);

      expect(find.text('Genel Ayarlar'), findsOneWidget);
      expect(find.text('Görünüm'), findsOneWidget);
      expect(find.text('Veri Durumu'), findsOneWidget);
      expect(find.text('Veritabanı Yedekleme & Geri Yükleme'), findsOneWidget);
      expect(find.text('Kullanım Bilgisi'), findsOneWidget);
    });

    testWidgets('displays correct data counts for personnel, task, and leave',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest(
        personnelCount: 7,
        taskCount: 4,
        leaveCount: 9,
      ));
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
    });

    testWidgets('shows warning feedback when app name is empty and saved',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(TextFormField, 'Personel ve Görev Yönetim Sistemi');
      expect(nameField, findsOneWidget);

      await tester.enterText(nameField, '');
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(FilledButton, 'Kaydet');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Uygulama adı boş bırakılamaz.'), findsOneWidget);
    });

    testWidgets('saves settings successfully with valid app name',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(TextFormField, 'Personel ve Görev Yönetim Sistemi');
      await tester.enterText(nameField, 'Yeni Sistem Adı');
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(FilledButton, 'Kaydet');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Genel ayarlar kaydedildi.'), findsOneWidget);
    });

    testWidgets('non-admin user cannot edit general settings or take backups',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1000));

      final officerUser = AppUser(
        id: 5,
        username: '555555',
        fullName: 'Ekip Memuru',
        role: UserRole.teamOfficer,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(user: officerUser));
      await tester.pumpAndSettle();

      // General settings save button is hidden
      expect(find.widgetWithText(FilledButton, 'Kaydet'), findsNothing);

      // Backup section displays permission lock warning
      expect(
        find.textContaining('Veritabanı yedekleme ve geri yükleme işlemleri yalnızca'),
        findsOneWidget,
      );
    });
  });
}

class _MockSettingsNotifier extends AsyncNotifier<AppSettings>
    implements SettingsNotifier {
  final AppSettings initialSettings;
  _MockSettingsNotifier(this.initialSettings);

  @override
  Future<AppSettings> build() async => initialSettings;

  @override
  Future<void> updateSettings(AppSettings settings) async {
    state = AsyncData(settings);
  }

  @override
  Future<void> updateLastBackupDate(DateTime date) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(lastBackupDate: date));
    }
  }
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
