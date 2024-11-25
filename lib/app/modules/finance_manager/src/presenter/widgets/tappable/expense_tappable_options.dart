import 'package:flutter/material.dart';
import '../../../domain/models/expense_model.dart';
import '../../controllers/account_store.dart';
import '../../controllers/expense_store.dart';
import 'tappable_option.dart';
import 'tappable_options_utils.dart';

abstract class ExpenseTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required ExpenseModel model,
    required ExpenseStore store,
    required AccountStore accountStore,
    VoidCallback? onPop,
  }) {
    return [
      TappableOption('Pagar', () {
        TappableOptionsUtils.navigateTo(
          route: '/expense/pay',
          context: context,
        ).then((_) {
          store.setSelectedModel(null);
          onPop?.call();
        });
      }),
      TappableOption(
        'Editar Despesa',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.navigateTo(
            context: context,
            route: '/expense/update',
          ).then((_) {
            store.setSelectedModel(null);
            onPop?.call();
          });
        },
      ),
      TappableOption('Alterar Valor', () {
        store.setSelectedModel(model);
        TappableOptionsUtils.handleChangeValue<ExpenseModel>(
          context: context,
          model: model,
          store: store,
          onPop: () {
            store.setSelectedModel(null);
            onPop?.call();
          },
        );
      }),
      TappableOption(
        'Trocar de Conta',
        () {
          store.setSelectedModel(model);

          TappableOptionsUtils.handleSwitchAccount<ExpenseModel>(
            context: context,
            accounts: accountStore.state,
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
      TappableOption('Deletar Despesa', () {}),
    ];
  }
}
