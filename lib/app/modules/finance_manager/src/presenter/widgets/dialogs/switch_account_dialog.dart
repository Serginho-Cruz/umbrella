import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';

import '../../../domain/entities/account.dart';
import '../../utils/umbrella_sizes.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../layout/dialog_layout.dart';
import '../layout/spaced.dart';
import '../selectors/account_selector.dart';
import '../simple_information/account_name.dart';
import '../simple_information/paiyable_name.dart';
import '../texts/medium_text.dart';
import '../texts/title_text.dart';
import 'umbrella_dialogs.dart';

class SwitchAccountDialog<P extends PaiyableModel> extends StatefulWidget {
  const SwitchAccountDialog({
    super.key,
    required this.onAccountChanged,
    required this.model,
    required this.accounts,
  });

  final P model;
  final Future<String?> Function(Account) onAccountChanged;
  final List<Account> accounts;

  @override
  State<SwitchAccountDialog> createState() => _SwitchAccountDialogState();
}

class _SwitchAccountDialogState extends State<SwitchAccountDialog> {
  late Account accountSelected;

  @override
  void initState() {
    super.initState();
    accountSelected = widget.model.account.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(child: TitleText.bold('Trocar Conta')),
          const SizedBox(height: 40.0),
          PaiyableName(model: widget.model),
          const SizedBox(height: 30.0),
          AccountName(
            account: widget.model.account,
            trailingText: 'Conta Atual:',
            alignment: MainAxisAlignment.start,
            minimalSpace: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: AccountSelector(
              accounts: widget.accounts,
              onSelected: (account) {
                setState(() {
                  accountSelected = account!;
                });
              },
              label: ('Conta Destino:'),
              fontSize: UmbrellaSizes.medium,
              canSelectNull: false,
              selectedAccount: accountSelected,
            ),
          ),
          Spaced(
            first: SecondaryButton(
              width: MediaQuery.sizeOf(context).width * 0.25,
              label: const MediumText.bold('Voltar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            second: PrimaryButton(
              width: MediaQuery.sizeOf(context).width * 0.4,
              icon: const Icon(
                Icons.edit_square,
                color: Colors.black,
                size: 24.0,
              ),
              label: const MediumText.bold('Trocar'),
              onPressed: switchAccount,
            ),
          ),
        ],
      ),
    );
  }

  void switchAccount() {
    if (accountSelected.id == widget.model.account.id) {
      Navigator.pop(context);
      return;
    }

    widget.onAccountChanged(accountSelected).then((error) {
      error != null
          ? UmbrellaDialogs.showError(
              context,
              error,
              onRetry: switchAccount,
              onConfirmPressed: () => Navigator.pop(context),
            )
          : Navigator.pop(context);
    });
  }
}
