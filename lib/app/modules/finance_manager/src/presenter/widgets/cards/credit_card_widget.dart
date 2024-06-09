import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import '../../../domain/entities/credit_card.dart';
import '../../../utils/hex_color.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    super.key,
    required this.creditCard,
    this.width = 275,
    this.height = 150,
    this.margin,
  });

  final CreditCard creditCard;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: kElevationToShadow[4],
        color: HexColor(creditCard.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BigText.bold(creditCard.name),
          ),
          Container(height: 15.0, color: Colors.black),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spaced(
                    first: const MediumText('Fec. da Fatura'),
                    second: MediumText(
                      'Dia ${creditCard.cardInvoiceClosingDay}',
                    ),
                  ),
                  Spaced(
                    first: const MediumText('Venc. da Fatura'),
                    second: MediumText('Dia ${creditCard.cardInvoiceDueDay}'),
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
