import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class PaymentCardContainer extends StatelessWidget {
  const PaymentCardContainer({
    super.key,
    required this.borderRadius,
    required this.children,
  });

  final double borderRadius;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.75,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: kElevationToShadow[4],
        color: UmbrellaPalette.secondaryColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
