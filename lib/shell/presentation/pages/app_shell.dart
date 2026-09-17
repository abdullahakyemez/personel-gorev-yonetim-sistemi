import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/presentation/dialogs/change_password_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/providers/sidebar_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_topbar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);
    final currentUser = ref.watch(currentUserProvider);

    // İlk giriş zorunlu şifre yenileme kalkanı:
    // Eğer kullanıcının requiresPasswordChange bayrağı true ise, sistem arka plandaki
    // hiçbir sayfayı (dashboard, personel vb.) render etmez ve doğrudan güvenli
    // şifre yenileme ekranını sunar.
    if (currentUser != null && currentUser.requiresPasswordChange) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ChangePasswordDialog(
              user: currentUser,
              isFirstLogin: true,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Scaffold(
          drawer: isMobile
              ? const Drawer(
                  child: SafeArea(
                    child: AppSidebar(
                      isExpanded: true,
                      isDrawer: true,
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!isMobile) AppSidebar(isExpanded: isExpanded),
                Expanded(
                  child: Column(
                    children: [
                      const AppTopbar(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 12 : 24),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
