import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import 'payment_card_border_painter.dart';

class PaymentCardContainer extends StatelessWidget {
  const PaymentCardContainer({
    super.key,
    required this.paymentMethod,
    required this.borderRadius,
    required this.children,
  });

  final PaymentMethod paymentMethod;
  final double borderRadius;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: PaymentCardBorderPainter(
        method: paymentMethod,
        borderRadius: borderRadius,
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: kElevationToShadow[4],
        ),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
