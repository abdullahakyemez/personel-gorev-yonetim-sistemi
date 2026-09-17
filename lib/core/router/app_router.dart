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
import 'package:personel_gorev_yonetim_sistemi/shell/presentation/pages/app_shell.dart';

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (_, next) {
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
        path: '/kullanicilar',
        builder: (context, state) {
          return const AppShell(child: UserManagementPage());
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
});

/// Geriye dönük uyumluluk için statik router referansı
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
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
      path: '/kullanicilar',
      builder: (context, state) {
        return const AppShell(child: UserManagementPage());
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
