import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/price.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/spaced_texts.dart';

import '../../domain/entities/date.dart';
import '../../domain/models/finance_model.dart';

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
    Color iconColor = Colors.white;
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
        boxShadow: const [
          BoxShadow(blurRadius: 4.0, offset: Offset(2, 2)),
        ],
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
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 50.0,
                ),
              ),
              Price(
                value: totalValue,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpacedTexts(
                  first: const Text(
                    'Vencimento:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  second: Text(
                    overdueDate.toString(format: DateFormat.ddmmyyyy),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SpacedTexts(
                  first: const Text(
                    'Pago:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  second: Price(
                    value: totalValue - remainingValue,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SpacedTexts(
                  first: const Text(
                    'Restante:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  second: Price(
                    value: remainingValue,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
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
