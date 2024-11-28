import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/account_store.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/states/state.dart';
import '../../stores/income_store.dart';
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
        ).then((_) {
          store.setSelectedModel(null);
          onPop?.call();
        }),
      ),
      TappableOption(
        'Editar Receita',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.navigateTo(
            context: context,
            route: '/income/update',
          ).then((_) {
            store.setSelectedModel(null);
            onPop?.call();
          });
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
            onPop: () {
              store.setSelectedModel(null);
              onPop?.call();
            },
          );
        },
      ),
      TappableOption(
        'Trocar de Conta',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.handleSwitchAccount<IncomeModel>(
            context: context,
            accounts: (accountStore.state as SuccessState<List<Account>>).state,
            model: model,
            store: store,
            onPop: () {
              store.setSelectedModel(null);
              onPop?.call();
            },
          );
        },
      ),
      TappableOption('Ver em detalhes', () {}),
      TappableOption('Estornar', () {}),
      TappableOption('Deletar Receita', () {}),
    ];
  }
}
