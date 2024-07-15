import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/paiyable.dart';
import '../texts/medium_text.dart';

class PaiyableName extends StatelessWidget {
  const PaiyableName({super.key, required this.paiyable});

  final Paiyable paiyable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MediumText(_resolvePaiyableDisplayName()),
        const SizedBox(width: 10.0),
        MediumText.bold(_resolvePaiyableName()),
      ],
    );
  }

  String _resolvePaiyableDisplayName() {
    return switch (paiyable) {
      Expense() => 'Despesa:',
      Income() => 'Receita:',
      Invoice() => 'Fatura:',
      Paiyable() => '',
    };
  }

  String _resolvePaiyableName() {
    if (paiyable is Income) {
      var inc = paiyable as Income;
      return inc.name;
    }

    if (paiyable is Expense) {
      var exp = paiyable as Expense;
      return exp.name;
    }

    var inv = paiyable as Invoice;
    return '${inv.card.name} / ${inv.closingDate.monthName} de ${inv.closingDate.year}';
  }
}
