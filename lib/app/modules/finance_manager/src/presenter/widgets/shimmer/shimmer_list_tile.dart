import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/umbrella_palette.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
    this.roundedOnTop = false,
    this.roundedOnBottom = false,
    this.width,
    this.height,
  });

  final bool roundedOnTop;
  final bool roundedOnBottom;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UmbrellaPalette.shimmerBaseColor,
      highlightColor: UmbrellaPalette.shimmerHighlightColor,
      child: Container(
        width: width ?? MediaQuery.sizeOf(context).width * 0.9,
        height: height ?? 100.0,
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: roundedOnTop ? const Radius.circular(8.0) : Radius.zero,
            topRight: roundedOnTop ? const Radius.circular(8.0) : Radius.zero,
            bottomLeft:
                roundedOnBottom ? const Radius.circular(8.0) : Radius.zero,
            bottomRight:
                roundedOnBottom ? const Radius.circular(8.0) : Radius.zero,
          ),
          color: UmbrellaPalette.gray,
        ),
      ),
    );
  }
}
