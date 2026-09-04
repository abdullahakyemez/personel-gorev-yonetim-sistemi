import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';

class PGYSSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const PGYSSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.outline,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: borderRadius ?? AppRadius.smRadius,
        ),
      ),
    );
  }
}
