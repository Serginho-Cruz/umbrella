import 'package:flutter/material.dart';

import '../../../domain/entities/payment_method.dart';
import '../icons/flippable_payment_method_icon.dart';
import '../layout/horizontal_infinity_container.dart';
import '../layout/horizontal_listview.dart';

class PaymentMethodFilter extends StatelessWidget {
  const PaymentMethodFilter({
    super.key,
    required this.initiallySelected,
    required this.onTapped,
  });

  final List<PaymentMethod> initiallySelected;

  final void Function(PaymentMethod) onTapped;

  @override
  Widget build(BuildContext context) {
    var methods = PaymentMethod.all;

    return HorizontallyInfinityContainer(
      noShadow: true,
      child: SizedBox(
        height: 120.0,
        child: HorizontalListView(
          itemCount: methods.length,
          itemCallback: (index) => Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: FlippablePaymentMethodIcon(
              method: methods[index],
              initiallyFlipped: initiallySelected.contains(methods[index]),
              onFlip: () => onTapped(methods[index]),
            ),
          ),
        ),
      ),
    );
  }
}
