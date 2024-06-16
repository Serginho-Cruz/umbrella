import 'package:flutter/material.dart';

import '../../../domain/entities/account.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';

class AccountSelector extends StatelessWidget {
  const AccountSelector({
    super.key,
    required this.accounts,
    required this.selectedAccount,
    required this.onSelected,
    this.label = 'Conta',
  });

  final String label;
  final List<Account> accounts;
  final Account selectedAccount;
  final void Function(Account) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Account>(
      tooltip: 'Mostrar Contas',
      itemBuilder: _buildMenuItems,
      position: PopupMenuPosition.under,
      child: Spaced(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        first: BigText(label),
        second: Row(children: [
          BigText.bold(selectedAccount.name),
          const Icon(Icons.arrow_drop_down_rounded, size: 32.0)
        ]),
      ),
    );
  }

  List<PopupMenuEntry<Account>> _buildMenuItems(BuildContext context) {
    return List.generate(
      accounts.length,
      (index) => PopupMenuItem(
        onTap: () {
          onSelected(accounts[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MediumText(accounts[index].name),
            const SizedBox(width: 25.0),
            Price.medium(accounts[index].actualBalance),
          ],
        ),
      ),
    );
  }
}
