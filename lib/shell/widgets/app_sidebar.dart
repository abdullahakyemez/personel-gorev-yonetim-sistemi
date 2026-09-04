import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/data/sidebar_menu.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar_header.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/selected_task_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/application/task_provider.dart';
import 'app_sidebar_item.dart';

class AppSidebar extends ConsumerWidget {
  final bool isExpanded;
  const AppSidebar({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
      width: isExpanded
          ? AppSizes.sidebarExpandedWidth
          : AppSizes.sidebarCollapsedWidth,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AppSidebarHeader(isExpanded: isExpanded),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: sidebarMenuItems.length,
              itemBuilder: (context, index) {
                final item = sidebarMenuItems[index];
                final currentRoute = GoRouterState.of(context).uri.path;

                return AppSidebarItem(
                  item: item,
                  selected: currentRoute == item.route,
                  isExpanded: isExpanded,
                  onTap: () {
                    if (currentRoute == '/gorevler' && item.route != '/gorevler') {
                      ref.read(selectedTaskIdProvider.notifier).state = null;
                      ref.read(taskSearchProvider.notifier).state = '';
                      ref.read(selectedTaskStatusProvider.notifier).state = null;
                      ref.read(selectedPersonnelProvider.notifier).state = null;
                      ref.read(selectedTaskCategoryProvider.notifier).state = null;
                    }
                    context.go(item.route);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 70),
        ],
      ),
    );
  }
}
