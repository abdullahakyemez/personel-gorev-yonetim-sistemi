import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/providers/sidebar_provider.dart';

class AppTopbar extends ConsumerWidget {
  const AppTopbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);
    return Container(
      height: AppSizes.topbarHeight,

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(width: .5, color: Theme.of(context).colorScheme.primary)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ref.read(sidebarExpandedProvider.notifier).state = !isExpanded;
            },
            icon: const Icon(Icons.menu),
          ),
          const Spacer(),
          const Text("Abdullah"),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)),
        ],
      ),
    );
  }
}
