// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/states/state.dart' as s;
import '../../utils/currency_format.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../layout/dialog_layout.dart';
import '../texts/medium_text.dart';
import 'umbrella_dialogs.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    required this.account,
    required this.store,
  });

  final Account account;
  final AccountStore store;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  late final ReactionDisposer _disposer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => widget.store.state, (st) async {
      switch (st) {
        case s.LoadingState():
          _isLoading = true;
          showDialog(
            context: context,
            builder: (ctx) {
              return const DialogLayout(
                child: SizedBox.square(
                  dimension: 250,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
          ).then((_) {
            _isLoading = false;
          });
          break;
        case s.FailState f:
          if (_isLoading) Navigator.pop(context);
          UmbrellaDialogs.showError(context, f.fail.message);
          break;
        case s.SuccessState():
          if (_isLoading) Navigator.pop(context);
          await UmbrellaDialogs.showSuccess(context,
              title: 'Deleção feita', message: 'Conta deletada com sucesso.');
          Navigator.pop(context);
          break;
      }
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.center,
            child: BigText.bold('Deletar Conta'),
          ),
          const SizedBox(height: 30),
          Wrap(
            direction: Axis.vertical,
            spacing: 25,
            children: [
              MediumText('Nome: ${widget.account.name}'),
              MediumText(
                  'Saldo: ${CurrencyFormat.format(widget.account.actualBalance)}'),
            ],
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.center,
            child: MediumText.bold('Prosseguir com a ação?'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryButton(
                width: 150,
                label: const MediumText('Cancelar'),
                icon: null,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              PrimaryButton(
                width: 150,
                label: const MediumText('Deletar'),
                onPressed: () => widget.store.delete(widget.account),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
