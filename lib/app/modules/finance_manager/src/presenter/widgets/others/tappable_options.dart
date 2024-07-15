import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/credit_card.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/paiyable.dart';
import '../../../domain/models/expense_model.dart';
import '../../../domain/models/income_model.dart';
import '../../../errors/errors.dart';
import '../../controllers/account_controller.dart';
import '../../controllers/expense_store.dart';
import '../../controllers/income_store.dart';
import '../dialogs/change_value_dialog.dart';
import '../dialogs/switch_account_dialog.dart';

abstract class TappableOptions {
  static List<({String name, VoidCallback onPressed})> incomes({
    required BuildContext context,
    required IncomeModel model,
    required IncomeStore store,
    required AccountStore accountStore,
    VoidCallback? onPop,
  }) {
    return [
      (name: 'Receber', onPressed: () {}),
      (name: 'Adiantar', onPressed: () {}),
      (
        name: 'Editar Receita',
        onPressed: () {
          _navigateTo(
            context: context,
            route: '/finance_manager/income/update',
            arguments: model.toEntity(),
          ).then((_) => onPop?.call());
        }
      ),
      (
        name: 'Alterar Valor',
        onPressed: () {
          _handleChangeValue<Income>(
            context: context,
            paiyable: model.toEntity(),
            onValueChanged: store.updateValue,
            onPop: onPop,
          );
        },
      ),
      (
        name: 'Trocar de Conta',
        onPressed: () {
          _handleSwitchAccount<Income>(
            context: context,
            accounts: accountStore.state,
            paiyable: model.toEntity(),
            onAccountChanged: store.switchAccount,
            onPop: onPop,
          );
        },
      ),
      (name: 'Ver em detalhes', onPressed: () {}),
      (name: 'Estornar', onPressed: () {}),
      (name: 'Deletar Receita', onPressed: () {}),
    ];
  }

  static List<({String name, VoidCallback onPressed})> expenses({
    required BuildContext context,
    required ExpenseModel model,
    required ExpenseStore store,
    required AccountStore accountStore,
    VoidCallback? onPop,
  }) {
    return [
      (name: 'Pagar', onPressed: () {}),
      (name: 'Parcelar', onPressed: () {}),
      (name: 'Re-parcelar', onPressed: () {}),
      (
        name: 'Editar Despesa',
        onPressed: () {
          _navigateTo(
            context: context,
            route: '/finance_manager/expense/update',
            arguments: model.toEntity(),
          ).then((_) => onPop?.call());
        }
      ),
      (
        name: 'Trocar de Conta',
        onPressed: () {
          _handleSwitchAccount<Expense>(
            context: context,
            accounts: accountStore.state,
            paiyable: model.toEntity(),
            onAccountChanged: store.switchAccount,
            onPop: onPop,
          );
        },
      ),
      (
        name: 'Alterar Valor',
        onPressed: () {
          _handleChangeValue<Expense>(
            context: context,
            paiyable: model.toEntity(),
            onValueChanged: store.updateValue,
            onPop: onPop,
          );
        },
      ),
      (name: 'Ver em detalhes', onPressed: () {}),
      (name: 'Estornar', onPressed: () {}),
      (name: 'Deletar Despesa', onPressed: () {}),
    ];
  }

  static List<({String name, VoidCallback onPressed})> cards({
    required BuildContext context,
    required CreditCard card,
    VoidCallback? onPop,
  }) {
    return [
      (
        name: 'Editar Cartão',
        onPressed: () {
          _navigateTo(
            context: context,
            route: '/finance_manager/card/update',
            arguments: card,
          ).then((_) {
            onPop?.call();
          });
        },
      ),
      (name: 'Ver Faturas', onPressed: () {}),
      (name: 'Ver em detalhes', onPressed: () {}),
      (name: 'Deletar Cartão', onPressed: () {}),
    ];
  }

  static Future<void> _navigateTo({
    required String route,
    required BuildContext context,
    Object? arguments,
  }) =>
      Navigator.of(context).pushNamed(
        '/finance_manager/card/update',
        arguments: arguments,
      );

  static void _handleChangeValue<P extends Paiyable>({
    required BuildContext context,
    required P paiyable,
    required AsyncResult<void, Fail> Function(P, double) onValueChanged,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeValueDialog(
        onValueAltered: (newValue) {
          return onValueChanged(paiyable, newValue).then((res) {
            if (res.isSuccess()) onPop?.call();
            return res.exceptionOrNull()?.message;
          });
        },
        paiyable: paiyable,
      ),
    );
  }

  static void _handleSwitchAccount<P extends Paiyable>({
    required BuildContext context,
    required List<Account> accounts,
    required P paiyable,
    required AsyncResult<void, Fail> Function(P, Account) onAccountChanged,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => SwitchAccountDialog(
        accounts: accounts,
        onAccountChanged: (account) {
          return onAccountChanged(paiyable, account).then((res) {
            if (res.isSuccess()) onPop?.call();
            return res.exceptionOrNull()?.message;
          });
        },
        paiyable: paiyable,
      ),
    );
  }
}
