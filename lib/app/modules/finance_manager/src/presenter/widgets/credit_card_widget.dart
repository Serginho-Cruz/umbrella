import 'package:flutter/material.dart';
import '../../domain/entities/date.dart';
import 'price.dart';
import 'spaced_texts.dart';

import '../../domain/models/credit_card_model.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    super.key,
    required this.creditCard,
  });

  final CreditCardModel creditCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 275,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: kElevationToShadow[4],
        color: Color(
          int.parse('0xFF${creditCard.color}'),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  creditCard.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Image(
                  image: AssetImage('assets/images/chip.png'),
                  height: 30.0,
                  width: 35.0,
                ),
              ],
            ),
          ),
          Container(
            height: 15.0,
            color: Colors.black,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SpacedTexts(
                    first: const Text(
                      'Total Gasto: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                    second: Price(
                      value: creditCard.castValue,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SpacedTexts(
                    first: const Text(
                      'Vencimento da Fatura',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    second: Text(
                      creditCard.overdueDate
                          .toString(format: DateFormat.ddmmyyyy),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
