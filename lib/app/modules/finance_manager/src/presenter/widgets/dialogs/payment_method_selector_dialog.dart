import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/dialog_layout.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../../domain/entities/payment_method.dart';

class PaymentMethodSelectorDialog extends StatelessWidget {
  const PaymentMethodSelectorDialog({
    super.key,
    required this.onSelected,
    required this.paymentMethods,
  });

  final void Function(PaymentMethod) onSelected;
  final List<PaymentMethod> paymentMethods;

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: PrimaryButton(
        label: const MediumText('Escolher'),
        onPressed: () {
          onSelected(paymentMethods.first);
          Navigator.pop(context);
        },
      ),
    );
  }
}
