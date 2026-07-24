import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/providers/sidebar_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_topbar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            AppSidebar(isExpanded: isExpanded),
            Expanded(
              //child: Padding(
              // padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const AppTopbar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: child,
                    ),
                  ),
                ],
              ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
