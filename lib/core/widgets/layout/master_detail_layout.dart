import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/responsive/breakpoints.dart';

class MasterDetailLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final bool detailVisible;
  final Duration animationDuration;
  final VoidCallback? onBack;
  final double breakpoint;

  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
    this.detailVisible = true,
    this.animationDuration = const Duration(milliseconds: 280),
    this.onBack,
    this.breakpoint = AppBreakpoints.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < breakpoint;

        if (isNarrow) {
          // Mobil / Dar ekran: Tek panel modu (Stacked navigation)
          if (detailVisible) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onBack != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Listeye Dön'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                Expanded(child: detail),
              ],
            );
          } else {
            return SizedBox(
              width: constraints.maxWidth,
              child: master,
            );
          }
        }

        // Geniş ekran: İki panel yan yana (Desktop / Tablet split view)
        if (!detailVisible) {
          return AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeInOut,
            width: constraints.maxWidth,
            child: master,
          );
        }

        final detailWidth = constraints.maxWidth * 0.42;
        final masterWidth = constraints.maxWidth - detailWidth - 16;

        return Row(
          children: [
            AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              width: masterWidth,
              child: master,
            ),
            const SizedBox(width: 16),
            AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              width: detailWidth,
              child: detail,
            ),
          ],
        );
      },
    );
  }
}

