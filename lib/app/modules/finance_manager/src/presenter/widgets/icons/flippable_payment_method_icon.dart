import 'package:flutter/material.dart';

import '../../../domain/entities/payment_method.dart';
import '../texts/medium_text.dart';
import 'flippable_icon.dart';
import 'payment_method_icon.dart';

class FlippablePaymentMethodIcon extends StatelessWidget {
  const FlippablePaymentMethodIcon({
    super.key,
    this.onFlip,
    required this.method,
    this.initiallyFlipped = false,
  });

  final PaymentMethod method;
  final bool initiallyFlipped;
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlippableIcon(
          radius: 60,
          initiallyFlipped: initiallyFlipped,
          onFlip: onFlip,
          render: (ctx) => PaymentMethodIcon(
            dimension: 60,
            method: method,
            circular: true,
            withBorder: true,
          ),
        ),
        const SizedBox(height: 10),
        MediumText(method.name),
      ],
    );
  }
}
