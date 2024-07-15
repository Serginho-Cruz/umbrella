import 'package:flutter/material.dart';

import '../../../domain/entities/account.dart';
import '../../utils/umbrella_sizes.dart';
import '../layout/spaced.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';

class AccountSelector extends StatelessWidget {
  const AccountSelector({
    super.key,
    required this.accounts,
    this.selectedAccount,
    required this.onSelected,
    this.label = 'Conta',
    this.canSelectNull = true,
    this.fontSize = UmbrellaSizes.big,
  });

  final String label;
  final double fontSize;
  final List<Account> accounts;
  final Account? selectedAccount;
  final void Function(Account?) onSelected;
  final bool canSelectNull;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Account>(
      tooltip: 'Mostrar Contas',
      itemBuilder: _buildMenuItems,
      position: PopupMenuPosition.under,
      child: Spaced(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        first: Text(label, style: TextStyle(fontSize: fontSize)),
        second: Row(
          children: [
            Text(
              selectedAccount?.name ?? 'Nenhuma',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, size: 32.0)
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<Account>> _buildMenuItems(BuildContext context) {
    return [
      if (canSelectNull)
        PopupMenuItem(
          onTap: () {
            onSelected(null);
          },
          child: const MediumText('Nenhuma'),
        ),
      ...List.generate(
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
      ),
    ];
  }
}
