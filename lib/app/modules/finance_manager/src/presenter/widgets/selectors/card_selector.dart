import 'package:flutter/material.dart';

import '../../../domain/entities/credit_card.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import 'base_selectors.dart';
import '../cards/credit_card_widget.dart';

class CardSelector extends StatelessWidget {
  const CardSelector({
    super.key,
    this.cardSelected,
    required this.cards,
    required this.onCardSelected,
  });

  final List<CreditCard> cards;
  final void Function(CreditCard) onCardSelected;
  final CreditCard? cardSelected;

  @override
  Widget build(BuildContext context) {
    return LinearSelector<CreditCard>(
      title: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: BigText('Selecione o Cartão'),
      ),
      items: cards,
      itemBuilder: (card) {
        return CreditCardWidget(
          creditCard: card,
          width: 225,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
        );
      },
      onItemTap: (card) {
        onCardSelected(card);
      },
      direction: Axis.horizontal,
      child: cardSelected != null
          ? CreditCardWidget(
              creditCard: cardSelected!,
              margin: const EdgeInsets.only(top: 15.0),
            )
          : Container(
              height: 150,
              width: 275,
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey,
              ),
              child: const Center(
                child: MediumText('Clique Aqui', color: Colors.white),
              ),
            ),
    );
  }
}
