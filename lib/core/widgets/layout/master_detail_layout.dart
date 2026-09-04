import 'package:flutter/material.dart';

class MasterDetailLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final bool detailVisible;
  final Duration animationDuration;

  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
    this.detailVisible = true,
    this.animationDuration = const Duration(milliseconds: 280),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
