import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/spaced_widgets.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/umbrella_sizes.dart';
import '../../domain/entities/credit_card.dart';

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
        color: Color(int.parse('0xFF${creditCard.color}')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              creditCard.name,
              style: const TextStyle(
                fontSize: UmbrellaSizes.big,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 15.0, color: Colors.black),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SpacedWidgets(
                    first: const Text(
                      'Fec. da Fatura',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: UmbrellaSizes.medium,
                      ),
                    ),
                    second: Text(
                      'Dia ${creditCard.cardInvoiceClosingDay}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: UmbrellaSizes.medium,
                      ),
                    ),
                  ),
                  SpacedWidgets(
                    first: const Text(
                      'Venc. da Fatura',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: UmbrellaSizes.medium,
                      ),
                    ),
                    second: Text(
                      'Dia ${creditCard.cardInvoiceDueDay}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: UmbrellaSizes.medium,
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
