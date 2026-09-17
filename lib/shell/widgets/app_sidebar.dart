import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/data/sidebar_menu.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'app_sidebar_item.dart';

class AppSidebar extends ConsumerWidget {
  final bool isExpanded;
  final bool isDrawer;

  const AppSidebar({
    super.key,
    required this.isExpanded,
    this.isDrawer = false,
  });

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

    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
      width: isDrawer
          ? double.infinity
          : (isExpanded
              ? AppSizes.sidebarExpandedWidth
              : AppSizes.sidebarCollapsedWidth),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AppSidebarHeader(isExpanded: isExpanded),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                String currentRoute = '';
                try {
                  currentRoute = GoRouterState.of(context).uri.path;
                } catch (_) {
                  currentRoute = '';
                }

                return AppSidebarItem(
                  item: item,
                  selected: currentRoute == item.route,
                  isExpanded: isExpanded,
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
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
