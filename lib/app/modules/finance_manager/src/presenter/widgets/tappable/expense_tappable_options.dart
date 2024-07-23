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
      TappableOption('Pagar', () {}),
      TappableOption('Parcelar', () {}),
      TappableOption('Re-parcelar', () {}),
      TappableOption(
        'Editar Despesa',
        () => TappableOptionsUtils.navigateTo(
          context: context,
          route: '/finance_manager/expense/update',
          arguments: model.toEntity(),
        ).then((_) => onPop?.call()),
      ),
      TappableOption(
        'Alterar Valor',
        () => TappableOptionsUtils.handleChangeValue<ExpenseModel>(
          context: context,
          model: model,
          onValueChanged: store.updateValue,
          onPop: onPop,
        ),
      ),
      TappableOption(
        'Trocar de Conta',
        () => TappableOptionsUtils.handleSwitchAccount<ExpenseModel>(
          context: context,
          accounts: accountStore.state,
          model: model,
          onAccountChanged: store.switchAccount,
          onPop: onPop,
        ),
      ),
      TappableOption('Ver em detalhes', () {}),
      TappableOption('Estornar', () {}),
      TappableOption('Deletar Despesa', () {}),
    ];
  }
}
