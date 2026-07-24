import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/models/sidebar_menu_item.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';

class AppSidebarItem extends StatelessWidget {
  final SidebarMenuItem item;
  final bool selected;
  final bool isExpanded;
  final VoidCallback? onTap;

  const AppSidebarItem({
    super.key,
    required this.item,
    required this.selected,
    required this.isExpanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.sidebarItemHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: AppRadius.justRightRadius,
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
        onTap: onTap,
        child: Row(
          children: [
            // Sol seçim çizgisi
            Container(
              width: 3,
              height: double.infinity,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isExpanded ? AppSpacing.md : AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),

                    if (isExpanded) ...[
                      const SizedBox(width: AppSpacing.md),

                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
