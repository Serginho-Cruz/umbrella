import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/umbrella_palette.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 25.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UmbrellaPalette.shimmerBaseColor,
      highlightColor: UmbrellaPalette.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: UmbrellaPalette.gray,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(),
        ),
      ),
    );
  }
}
