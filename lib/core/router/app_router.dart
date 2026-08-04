import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/pages/leave_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/pages/personnel_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/pages/reports_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/presentation/pages/settings_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/task_page.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/presentation/pages/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const AppShell(child: DashboardPage());
      },
    ),
    GoRoute(
      path: '/personeller',
      builder: (context, state) {
        return const AppShell(child: PersonnelPage());
      },
    ),
    GoRoute(
      path: '/gorevler',
      builder: (context, state) {
        return const AppShell(child: TaskPage());
      },
    ),
    GoRoute(
      path: '/izinler',
      builder: (context, state) {
        return const AppShell(child: LeavePage());
      },
    ),
    GoRoute(
      path: '/raporlar',
      builder: (context, state) {
        return const AppShell(child: ReportsPage());
      },
    ),
    GoRoute(
      path: '/ayarlar',
      builder: (context, state) {
        return const AppShell(child: SettingsPage());
      },
    ),
  ],
);
