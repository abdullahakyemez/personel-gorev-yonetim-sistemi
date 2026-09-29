import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/pages/login_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/pages/user_management_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/leave_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/pages/personnel_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/pages/reports_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/presentation/pages/settings_page.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/presentation/task_page.dart';
import 'package:personel_gorev_yonetim_sistemi/core/services/window_service.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/presentation/pages/app_shell.dart';

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
      final wasLoggedIn = previous?.value != null;
      final isLoggedIn = next.value != null;

      if (!wasLoggedIn && isLoggedIn) {
        WindowService.setToAppSize();
      } else if (wasLoggedIn && !isLoggedIn) {
        WindowService.setToLoginSize();
      }

      notifyListeners();
    });
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthListenable(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // Oturum kontrolü devam ediyorsa yönlendirme yapma
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      if (state.matchedLocation == '/kullanicilar') {
        final canManage =
            ref.read(hasPermissionProvider(AppPermission.manageUsers));
        if (!canManage) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/personeller',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PersonnelPage(),
            ),
          ),
          GoRoute(
            path: '/gorevler',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TaskPage(),
            ),
          ),
          GoRoute(
            path: '/izinler',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LeavePage(),
            ),
          ),
          GoRoute(
            path: '/raporlar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReportsPage(),
            ),
          ),
          GoRoute(
            path: '/kullanicilar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UserManagementPage(),
            ),
          ),
          GoRoute(
            path: '/ayarlar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
});

/// Geriye dönük uyumluluk için statik router referansı
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/personeller',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PersonnelPage(),
          ),
        ),
        GoRoute(
          path: '/gorevler',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TaskPage(),
          ),
        ),
        GoRoute(
          path: '/izinler',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeavePage(),
          ),
        ),
        GoRoute(
          path: '/raporlar',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReportsPage(),
          ),
        ),
        GoRoute(
          path: '/kullanicilar',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: UserManagementPage(),
          ),
        ),
        GoRoute(
          path: '/ayarlar',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
