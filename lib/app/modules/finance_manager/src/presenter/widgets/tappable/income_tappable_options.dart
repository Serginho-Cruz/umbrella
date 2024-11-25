import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import '../../controllers/income_store.dart';
import 'tappable_option.dart';
import 'tappable_options_utils.dart';
import '../../../domain/models/income_model.dart';

abstract class IncomeTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required IncomeModel model,
    required IncomeStore store,
    required AccountStore accountStore,
    VoidCallback? onPop,
  }) {
    return [
      TappableOption(
        'Receber',
        () => TappableOptionsUtils.navigateTo(
          context: context,
          route: '/income/pay',
          arguments: {'model': model},
        ).then((_) => onPop?.call()),
      ),
      TappableOption(
        'Editar Receita',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.navigateTo(
            context: context,
            route: '/income/update',
            arguments: model.toEntity(),
          ).then((_) => onPop?.call());
        },
      ),
      TappableOption(
        'Alterar Valor',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.handleChangeValue<IncomeModel>(
            context: context,
            model: model,
            store: store,
            onPop: onPop,
          );
        },
      ),
      TappableOption(
        'Trocar de Conta',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.handleSwitchAccount<IncomeModel>(
            context: context,
            accounts: accountStore.state,
            model: model,
            store: store,
            onPop: onPop,
          );
        },
      ),
      TappableOption('Ver em detalhes', () {}),
      TappableOption('Estornar', () {}),
      TappableOption('Deletar Receita', () {}),
    ];
  }
}
