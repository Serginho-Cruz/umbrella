import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/umbrella_sizes.dart';
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
    Color iconBackgroundColor;
    IconData icon;

    switch (status) {
      case Status.okay:
        iconBackgroundColor = Colors.green.shade800;
        icon = Icons.check_rounded;
        break;
      case Status.inTime:
        iconBackgroundColor = Colors.orange.shade400;
        icon = Icons.access_time_rounded;
        break;
      case Status.overdue:
        iconBackgroundColor = Colors.red.shade400;
        icon = Icons.close_rounded;
        break;
    }

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
          colors: [
            Color.fromRGBO(129, 219, 251, 1),
            Color.fromRGBO(200, 136, 251, 1)
          ],
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
              Material(
                color: iconBackgroundColor,
                shape: const CircleBorder(
                  side: BorderSide(
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 50.0),
              ),
              Price(
                value: totalValue,
                fontSize: UmbrellaSizes.big,
                fontWeight: FontWeight.bold,
              )
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
                  second: Price(
                    value: totalValue - remainingValue,
                    fontSize: UmbrellaSizes.medium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spaced(
                  first: const MediumText('Restante'),
                  second: Price(
                    value: remainingValue,
                    fontSize: UmbrellaSizes.medium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
