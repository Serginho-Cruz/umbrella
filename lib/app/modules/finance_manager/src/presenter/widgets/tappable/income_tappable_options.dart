import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import 'tappable_option.dart';
import 'tappable_options_utils.dart';
import '../../../domain/models/income_model.dart';
import '../../controllers/income_store.dart';

abstract class IncomeTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required IncomeModel model,
    required IncomeStore store,
    required AccountStore accountStore,
    VoidCallback? onPop,
  }) {
    return [
      TappableOption('Receber', () {}),
      TappableOption(
        'Editar Receita',
        () => TappableOptionsUtils.navigateTo(
          context: context,
          route: '/income/update',
          arguments: model.toEntity(),
        ).then((_) => onPop?.call()),
      ),
      TappableOption(
        'Alterar Valor',
        () => TappableOptionsUtils.handleChangeValue<IncomeModel>(
          context: context,
          model: model,
          onValueChanged: store.updateValue,
          onPop: onPop,
        ),
      ),
      TappableOption(
        'Trocar de Conta',
        () => TappableOptionsUtils.handleSwitchAccount<IncomeModel>(
          context: context,
          accounts: accountStore.state,
          model: model,
          onAccountChanged: store.switchAccount,
          onPop: onPop,
        ),
      ),
      TappableOption('Ver em detalhes', () {}),
      TappableOption('Estornar', () {}),
      TappableOption('Deletar Receita', () {}),
    ];
  }
}
