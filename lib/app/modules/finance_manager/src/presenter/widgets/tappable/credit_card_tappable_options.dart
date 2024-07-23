import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'tappable_option.dart';
import 'tappable_options_utils.dart';

abstract class CreditCardTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required CreditCard card,
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
      TappableOption('Deletar Cartão', () {}),
    ];
  }
}
