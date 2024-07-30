import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_paiyable_name.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_palette.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/price.dart';

import '../../../domain/entities/invoice.dart';

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
      height: 230.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        boxShadow: kElevationToShadow[4],
        borderRadius: BorderRadius.circular(8.0),
        gradient: const LinearGradient(
          colors: UmbrellaPalette.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigText.bold(resolvePaiyableName(model)),
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
        first: const MediumText('Devendo a:'),
        second: MediumText(person),
      );

      return [(5, widget)];
    }

    if (paiyable is Income) {
      var person = paiyable.personName;

      if (person == null) return [];

      var widget = Spaced(
        first: const MediumText('Devedor:'),
        second: MediumText(person),
      );

      return [(5, widget)];
    }

    paiyable = paiyable as Invoice;
    var cardRow = Spaced(
      first: const MediumText('Cartão:'),
      second: MediumText(paiyable.card.name),
    );

    var closeRow = Spaced(
      first: const MediumText('Fechamento:'),
      second: MediumText(
        paiyable.closingDate.toString(format: DateFormat.ddmmyyyy),
      ),
    );

    return [(1, cardRow), (4, closeRow)];
  }

  List<Widget> _getCommomInformations() {
    return [
      Spaced(
        first: const MediumText('Pertence a:'),
        second: MediumText(model.account.name),
      ),
      Spaced(
        first: const MediumText('Total:'),
        second: Price.medium(model.totalValue),
      ),
      Spaced(
        first: const MediumText('Já Pago:'),
        second: Price.medium(model.paidValue),
      ),
      Spaced(
        first: const MediumText('Valor Restante:'),
        second: Price.medium(model.remainingValue),
      ),
      Spaced(
        first: const MediumText('Valor Restante:'),
        second: MediumText(
          model.overdueDate.toString(
            format: DateFormat.ddmmyyyy,
          ),
        ),
      ),
    ];
  }
}
