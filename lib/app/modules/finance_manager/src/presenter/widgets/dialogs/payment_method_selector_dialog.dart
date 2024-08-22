import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/dialog_layout.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/extrabig_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../../domain/entities/payment_method.dart';

class PaymentMethodSelectorDialog extends StatefulWidget {
  const PaymentMethodSelectorDialog({
    super.key,
    required this.onSelected,
    required this.paymentMethods,
  });

  final void Function(PaymentMethod) onSelected;
  final List<PaymentMethod> paymentMethods;

  @override
  State<PaymentMethodSelectorDialog> createState() =>
      _PaymentMethodSelectorDialogState();
}

class _PaymentMethodSelectorDialogState
    extends State<PaymentMethodSelectorDialog> {
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Extrabig.bold(
              'Escolha o Método de Pagamento',
              textAlign: TextAlign.center,
            ),
          ),
          for (var method in widget.paymentMethods)
            RadioListTile<PaymentMethod>(
              groupValue: _selectedMethod,
              value: method,
              onChanged: _onMethodSelected,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage(
                        'assets/icons/payment_methods/${method.icon}'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 20.0),
                  MediumText(method.name),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          const SizedBox(height: 20.0),
          PrimaryButton(
            label: const MediumText('Escolher'),
            onPressed: _onPressed,
          ),
        ],
      ),
    );
  }

  void _onMethodSelected(PaymentMethod? selected) {
    setState(() {
      _selectedMethod = selected;
    });
  }

  void _onPressed() {
    if (_selectedMethod != null) {
      widget.onSelected(_selectedMethod!);
    }

    Navigator.pop(context);
  }
}
