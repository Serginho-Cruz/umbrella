import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/edit_account_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/set_default_account_dialog.dart';

import '../../stores/account_store.dart';
import '../dialogs/delete_account_dialog.dart';
import 'tappable_option.dart';

abstract class AccountTappableOptions {
  static List<TappableOption> get({
    required BuildContext context,
    required Account account,
    required AccountStore store,
    VoidCallback? onPop,
  }) {
    return [
      TappableOption('Editar', () {
        showDialog(
          context: context,
          builder: (ctx) => EditAccountDialog(
            accountStore: store,
            acc: account,
          ),
        ).then((_) {
          store.cleanFields();

          onPop?.call();
        });
      }),
      if (account.isDefault == false)
        TappableOption('Definir como Padrão', () {
          showDialog(
            context: context,
            builder: (ctx) => SetDefaultAccountDialog(
              store: store,
              account: account,
            ),
          ).then((_) {
            store.cleanFields();
            onPop?.call();
          });
        }),
      if (account.isDefault == false)
        TappableOption('Deletar', () {
          showDialog(
            context: context,
            builder: (ctx) => DeleteAccountDialog(
              store: store,
              account: account,
            ),
          ).then((_) {
            store.cleanFields();

            onPop?.call();
          });
        }),
    ];
  }
}
