import 'package:flutter/material.dart';
import '../../../utils/umbrella_palette.dart';
import '../icons/status_icon.dart';
import '../texts/price.dart';
import '../layout/spaced.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/models/finance_model.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';

abstract class FinanceCard extends StatelessWidget {
  final String name;
  final double totalValue;
  final double remainingValue;
  final Status status;
  final Date overdueDate;

  const FinanceCard({
    super.key,
    required this.name,
    required this.totalValue,
    required this.remainingValue,
    required this.status,
    required this.overdueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        border: Border.all(width: 1.2),
        borderRadius: BorderRadius.circular(25.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: UmbrellaPalette.gradientColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusIcon(status: status, size: 50.0),
              Price.big(totalValue, fontWeight: FontWeight.bold)
            ],
          ),
          const SizedBox(height: 20.0),
          BigText.bold(name, textAlign: TextAlign.center),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spaced(
                  first: const MediumText('Vencimento'),
                  second: MediumText(
                    overdueDate.toString(format: DateFormat.ddmmyyyy),
                  ),
                ),
                Spaced(
                  first: const MediumText('Pago'),
                  second: Price.medium(totalValue - remainingValue),
                ),
                Spaced(
                  first: const MediumText('Restante'),
                  second: Price.medium(remainingValue),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
