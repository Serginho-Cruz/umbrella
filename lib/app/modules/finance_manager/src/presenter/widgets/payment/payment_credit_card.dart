import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_card_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/selectors/card_selector.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/payment_method.dart';
import '../../utils/umbrella_sizes.dart';
import '../forms/number_text_field.dart';
import '../selectors/account_selector.dart';

class PaymentCreditCard extends StatefulWidget {
  const PaymentCreditCard({
    super.key,
    required this.accounts,
    required this.creditCards,
    required this.initiallySelectedAccount,
    required this.onAccountChanged,
    required this.onValueChanged,
    required this.onCardChanged,
  });

  final List<Account> accounts;
  final List<CreditCard> creditCards;
  final Account initiallySelectedAccount;
  final void Function(Account) onAccountChanged;
  final void Function(double) onValueChanged;
  final void Function(CreditCard?) onCardChanged;

  @override
  State<PaymentCreditCard> createState() => _PaymentCreditCardState();
}

class _PaymentCreditCardState extends State<PaymentCreditCard> {
  late Account selectedAccount;
  CreditCard? selectedCard;

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.initiallySelectedAccount.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return PaymentCardContainer(
      paymentMethod: const PaymentMethod.credit(),
      borderRadius: 8.0,
      children: [
        const SizedBox(height: 4.0),
        AccountSelector(
          accounts: widget.accounts,
          onSelected: onAccountSelected,
          selectedAccount: selectedAccount,
          label: 'Conta',
          fontSize: UmbrellaSizes.medium,
          canSelectNull: false,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
        ),
        CardSelector(
          cards: widget.creditCards,
          onCardSelected: onCardSelected,
          cardSelected: selectedCard,
          buildChild: (card) {
            return Spaced(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              first: const MediumText('Cartão'),
              second: MediumText.bold(card?.name ?? 'Não Escolhido'),
            );
          },
        ),
        const SizedBox(height: 12.0),
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

  void onAccountSelected(Account? account) {
    //Account can't be null
    Account newSelected = account!;
    if (selectedAccount == newSelected) return;

    widget.onAccountChanged(newSelected);
    setState(() {
      selectedAccount = newSelected.copyWith();
    });
  }

  void onCardSelected(CreditCard newSelected) {
    widget.onCardChanged(newSelected);
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
}
