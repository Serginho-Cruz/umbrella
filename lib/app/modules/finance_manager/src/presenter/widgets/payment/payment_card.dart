import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_sizes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/number_text_field.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_card_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/selectors/account_selector.dart';

import '../../../domain/entities/account.dart';

class PaymentCard extends StatefulWidget {
  const PaymentCard({
    super.key,
    required this.paymentMethod,
    required this.accounts,
    required this.initiallySelectedAccount,
    required this.onAccountChanged,
    required this.onValueChanged,
  });

  final PaymentMethod paymentMethod;
  final List<Account> accounts;
  final Account initiallySelectedAccount;
  final void Function(Account) onAccountChanged;
  final void Function(double) onValueChanged;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  late Account selectedAccount;

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.initiallySelectedAccount.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return PaymentCardContainer(
      paymentMethod: widget.paymentMethod,
      borderRadius: 8.0,
      children: [
        AccountSelector(
          accounts: widget.accounts,
          onSelected: onAccountSelected,
          selectedAccount: selectedAccount,
          label: 'Conta',
          fontSize: UmbrellaSizes.medium,
          canSelectNull: false,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        NumberTextField(
          label: 'Valor',
          validate: validateValue,
          isCurrency: true,
          initialValue: 0.00,
          onChange: onValueChanged,
        )
      ],
    );
  }

  void onValueChanged(double? newValue) {
    double value = newValue ?? 0.00;

    widget.onValueChanged(value);
  }

  String? validateValue(double value) {
    if (value <= 0.00) {
      return 'O Valor digitado é 0 ou menos. Por favor, coloque um valor positivo';
    }

    return null;
  }

  void onAccountSelected(Account? account) {
    //Account can't be null
    Account newSelected = account!;
    if (selectedAccount == newSelected) return;

    widget.onAccountChanged(newSelected);
    setState(() {
      selectedAccount = newSelected.copyWith();
    });
  }
}
