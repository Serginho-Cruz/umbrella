import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/models/paiyable_model.dart';
import '../../../errors/errors.dart';
import '../dialogs/change_value_dialog.dart';
import '../dialogs/switch_account_dialog.dart';

abstract class TappableOptionsUtils {
  static Future<void> navigateTo({
    required String route,
    required BuildContext context,
    Object? arguments,
  }) =>
      Navigator.of(context).pushNamed(
        '/finance_manager$route',
        arguments: arguments,
      );

  static void handleChangeValue<P extends PaiyableModel>({
    required BuildContext context,
    required P model,
    required AsyncResult<void, Fail> Function(P, double) onValueChanged,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeValueDialog(
        onValueAltered: (newValue) {
          return onValueChanged(model, newValue).then((res) {
            if (res.isSuccess()) onPop?.call();
            return res.exceptionOrNull()?.message;
          });
        },
        model: model,
      ),
    );
  }

  static void handleSwitchAccount<P extends PaiyableModel>({
    required BuildContext context,
    required List<Account> accounts,
    required P model,
    required AsyncResult<void, Fail> Function(P, Account) onAccountChanged,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => SwitchAccountDialog(
        accounts: accounts,
        onAccountChanged: (account) {
          return onAccountChanged(model, account).then((res) {
            if (res.isSuccess()) onPop?.call();
            return res.exceptionOrNull()?.message;
          });
        },
        model: model,
      ),
    );
  }
}
