import 'package:flutter/material.dart';

import '../../../domain/entities/account.dart';
import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_sizes.dart';
import '../common/spaced_widgets.dart';

class AccountSelector extends StatelessWidget {
  const AccountSelector({
    super.key,
    required this.accounts,
    required this.selectedAccount,
    required this.onSelected,
    this.label = 'Conta',
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final List<Account> accounts;
  final Account selectedAccount;
  final void Function(Account) onSelected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Account>(
      tooltip: 'Mostrar Contas',
      itemBuilder: _buildMenuItems,
      position: PopupMenuPosition.under,
      child: SpacedWidgets(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        first: Text(
          label,
          style: const TextStyle(fontSize: UmbrellaSizes.big),
        ),
        second: Row(children: [
          Text(
            selectedAccount.name,
            style: const TextStyle(
              fontSize: UmbrellaSizes.big,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            Text(
              accounts[index].name,
              style: const TextStyle(
                fontSize: UmbrellaSizes.medium,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(width: 25.0),
            Text(
              CurrencyFormat.format(accounts[index].actualBalance),
              style: const TextStyle(
                fontSize: UmbrellaSizes.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
