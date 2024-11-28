import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_paiyable_name.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/price.dart';

import '../../../domain/entities/invoice.dart';
import '../texts/small_text.dart';

class PaiyableInformationCard extends StatelessWidget {
  const PaiyableInformationCard({super.key, required this.model});

  final PaiyableModel model;

  @override
  Widget build(BuildContext context) {
    List<Widget> informations = _getCommomInformations();

    int aux = 0;

    for (var info in _getSpecificInformations()) {
      informations.insert(info.$1 + aux, info.$2);
      aux++;
    }

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 200.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        boxShadow: kElevationToShadow[4],
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediumText.bold(resolvePaiyableName(model)),
          ...informations,
        ],
      ),
    );
  }

  List<(int, Widget)> _getSpecificInformations() {
    var paiyable = model.toEntity();

    if (paiyable is Expense) {
      var person = paiyable.personName;

      if (person == null) return [];

      var widget = Spaced(
        first: const SmallText('Devendo a'),
        second: SmallText(person),
      );

      return [(5, widget)];
    }

    if (paiyable is Income) {
      var person = paiyable.personName;

      if (person == null) return [];

      var widget = Spaced(
        first: const SmallText('Devedor'),
        second: SmallText(person),
      );

      return [(5, widget)];
    }

    paiyable = paiyable as Invoice;
    var cardRow = Spaced(
      first: const SmallText('Cartão'),
      second: SmallText(paiyable.card.name),
    );

    var closeRow = Spaced(
      first: const SmallText('Fechamento'),
      second: SmallText(
        paiyable.closingDate.toString(format: DateFormat.ddmmyyyy),
      ),
    );

    return [(1, cardRow), (4, closeRow)];
  }

  List<Widget> _getCommomInformations() {
    return [
      Spaced(
        first: const SmallText('Pertence a'),
        second: SmallText(model.account.name),
      ),
      Spaced(
        first: const SmallText('Total'),
        second: Price.small(model.totalValue),
      ),
      Spaced(
        first: const SmallText('Já Pago'),
        second: Price.small(model.paidValue),
      ),
      Spaced(
        first: const SmallText('Valor Restante'),
        second: Price.small(model.remainingValue),
      ),
      Spaced(
        first: const SmallText('Data de Vencimento'),
        second: SmallText(
          model.overdueDate.toString(
            format: DateFormat.ddmmyyyy,
          ),
        ),
      ),
    ];
  }
}
