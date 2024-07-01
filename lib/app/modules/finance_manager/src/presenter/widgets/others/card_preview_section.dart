import 'package:flutter/widgets.dart';

import '../../../domain/entities/credit_card.dart';
import '../cards/credit_card_widget.dart';
import '../texts/big_text.dart';

class CardPreviewSection extends StatelessWidget {
  const CardPreviewSection({
    super.key,
    required this.card,
    this.isToShow = true,
  });

  final CreditCard card;
  final bool isToShow;

  @override
  Widget build(BuildContext context) {
    return isToShow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: BigText('Pré-visualização'),
              ),
              CreditCardWidget(
                margin: const EdgeInsets.symmetric(vertical: 25.0),
                creditCard: card,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
