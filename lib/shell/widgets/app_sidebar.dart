import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_durations.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/data/sidebar_menu.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar_header.dart';
import 'app_sidebar_item.dart';

class AppSidebar extends StatelessWidget {
  final bool isExpanded;
  const AppSidebar({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
      width: isExpanded
          ? AppSizes.sidebarExpandedWidth
          : AppSizes.sidebarCollapsedWidth,
      color: AppColors.surface,
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
