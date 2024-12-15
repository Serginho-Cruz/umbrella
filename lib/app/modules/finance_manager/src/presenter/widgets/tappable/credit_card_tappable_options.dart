import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import '../../stores/credit_card_store.dart';
import '../dialogs/delete_card_dialog.dart';
import 'tappable_option.dart';
import 'tappable_options_utils.dart';

abstract class CreditCardTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required CreditCard card,
    required CreditCardStore store,
    VoidCallback? onPop,
  }) {
    return [
      TappableOption(
        'Editar Cartão',
        () {
          TappableOptionsUtils.navigateTo(
            context: context,
            route: '/card/update',
            arguments: card,
          ).then((_) => onPop?.call());
        },
      ),
      TappableOption('Ver Faturas', () {}),
      TappableOption('Ver em detalhes', () {}),
      TappableOption('Deletar Cartão', () {
        store.setCreditCard(card);

        showDialog(
          context: context,
          builder: (ctx) => DeleteCardDialog(store: store, card: card),
        ).then((_) {
          store.setCreditCard(null);
          onPop?.call();
        });
      }),
    ];
  }
}
