import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/paiyable_store.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/models/paiyable_model.dart';
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
    required PaiyableStore store,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeValueDialog(
        store: store,
        model: model,
      ),
    );
  }

  static void handleSwitchAccount<P extends PaiyableModel>({
    required BuildContext context,
    required List<Account> accounts,
    required P model,
    required PaiyableStore store,
    VoidCallback? onPop,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => SwitchAccountDialog(
        accounts: accounts,
        store: store,
        model: model,
      ),
    );
  }
}
