import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/responsive/breakpoints.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/application/leave_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/data/sidebar_menu.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar_header.dart';
import 'app_sidebar_item.dart';

class AppSidebar extends ConsumerWidget {
  final bool isExpanded;
  final bool isDrawer;

  const AppSidebar({
    super.key,
    required this.isExpanded,
    this.isDrawer = false,
  });

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Oturumu Kapat',
      message:
          'Mevcut oturumunuz sonlandırılacak ve giriş ekranına yönlendirileceksiniz. Devam etmek istiyor musunuz?',
      confirmText: 'Çıkış Yap',
      cancelText: 'Vazgeç',
      isDestructive: false,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) {
        PGYSFeedback.showSuccess(context, 'Oturum başarıyla kapatıldı.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManageUsers =
        ref.watch(hasPermissionProvider(AppPermission.manageUsers));
    final visibleItems = sidebarMenuItems.where((item) {
      if (item.route == '/kullanicilar') {
        return canManageUsers;
      }
      return true;
    }).toList();

    final personnelCount = ref.watch(personnelListProvider).value?.length;
    final taskCount = ref.watch(taskControllerProvider).value?.length;
    final leaveCount = ref.watch(leaveControllerProvider).value?.length;

    final isMobile = AppBreakpoints.isMobile(context);
    final effectiveExpanded = !isDrawer && isMobile ? false : isExpanded;

    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
      width: isDrawer
          ? double.infinity
          : (effectiveExpanded
              ? AppSizes.sidebarExpandedWidth
              : AppSizes.sidebarCollapsedWidth),
      color: AppColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebarHeader(isExpanded: effectiveExpanded),
          if (effectiveExpanded)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'YÖNETİM MENÜSÜ',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                String currentRoute = '';
                try {
                  currentRoute = GoRouterState.of(context).uri.path;
                } catch (_) {
                  currentRoute = '';
                }

                String? badgeText;
                if (item.route == '/personeller' && personnelCount != null) {
                  badgeText = '$personnelCount';
                } else if (item.route == '/gorevler' && taskCount != null) {
                  badgeText = '$taskCount';
                } else if (item.route == '/izinler' && leaveCount != null) {
                  badgeText = '$leaveCount';
                }

                return AppSidebarItem(
                  item: item,
                  selected: currentRoute == item.route,
                  isExpanded: effectiveExpanded,
                  badgeText: badgeText,
                  onTap: () {
                    if (currentRoute == '/gorevler' &&
                        item.route != '/gorevler') {
                      ref.read(selectedTaskIdProvider.notifier).state = null;
                      ref.read(taskSearchProvider.notifier).state = '';
                      ref.read(selectedTaskStatusProvider.notifier).state =
                          null;
                      ref.read(selectedPersonnelProvider.notifier).state = null;
                      ref.read(selectedTaskCategoryProvider.notifier).state =
                          null;
                    }

                    if (isDrawer && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    context.go(item.route);
                  },
                );
              },
            ),
          ),
          _buildUserProfile(context, ref, effectiveExpanded: effectiveExpanded),
        ],
      ),
    );
  }

  Widget _buildUserProfile(
    BuildContext context,
    WidgetRef ref, {
    required bool effectiveExpanded,
  }) {
    final currentUser = ref.watch(currentUserProvider);
    final fullName = currentUser?.fullName ?? 'Abdullah HAKYEMEZ';
    final username = currentUser?.username ?? '430558';

    String initials = 'AH';
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      initials = '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials = parts[0][0].toUpperCase();
    }

    if (!effectiveExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: IconButton(
            tooltip: 'Oturumu Kapat',
            onPressed: () => _handleLogout(context, ref),
            icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 22),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF14272F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF1E5F74),
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sicil: $username',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Oturumu Kapat',
            onPressed: () => _handleLogout(context, ref),
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
