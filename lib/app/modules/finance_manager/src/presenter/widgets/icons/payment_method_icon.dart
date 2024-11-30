import 'package:flutter/material.dart';

import '../../../domain/entities/payment_method.dart';

class PaymentMethodIcon extends StatelessWidget {
  const PaymentMethodIcon({
    super.key,
    required this.dimension,
    required this.method,
    this.withBorder = true,
    this.circular = false,
  });

  final double dimension;
  final PaymentMethod method;
  final bool withBorder;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        border: withBorder ? Border.all(width: 1.0) : const Border(),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: AssetImage('assets/icons/payment_methods/${method.icon}'),
        ),
      ),
    );
  }
}
