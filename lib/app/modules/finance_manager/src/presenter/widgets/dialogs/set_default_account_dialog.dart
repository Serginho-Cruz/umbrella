import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_sizes.dart';

import '../../../domain/states/state.dart' as s;
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../layout/dialog_layout.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/title_text.dart';
import 'umbrella_dialogs.dart';

class SetDefaultAccountDialog extends StatefulWidget {
  const SetDefaultAccountDialog({
    super.key,
    required this.store,
    required this.account,
  });

  final AccountStore store;
  final Account account;

  @override
  State<SetDefaultAccountDialog> createState() =>
      _SetDefaultAccountDialogState();
}

class _SetDefaultAccountDialogState extends State<SetDefaultAccountDialog> {
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
          ).then((_) => _isLoading = false);
          break;
        case s.SuccessState():
          if (_isLoading) Navigator.pop(context);
          await UmbrellaDialogs.showSuccess(
            context,
            title: 'Operação bem sucedida',
            message:
                'A conta ${widget.account.name} foi definida como padrão com sucesso',
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          break;
        case s.FailState failState:
          if (_isLoading) Navigator.pop(context);
          UmbrellaDialogs.showError(context, failState.fail.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Material(
              shape: CircleBorder(
                side: BorderSide(color: Colors.black, width: 3.0),
              ),
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Icon(Icons.warning, color: Colors.black, size: 60.0),
              ),
            ),
            const SizedBox(height: 30.0),
            const TitleText.bold('Atenção!!!', textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: 'Você está prestes a definir sua conta '),
                  TextSpan(
                    text: '"${widget.account.name}"',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' Como sua nova '),
                  const TextSpan(
                    text: 'Conta Padrão.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: UmbrellaSizes.medium,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30.0),
            const BigText.bold('Prosseguir?'),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SecondaryButton(
                  width: 130,
                  label: const MediumText('Cancelar'),
                  icon: null,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                PrimaryButton(
                  width: 130,
                  label: const MediumText('Continuar'),
                  onPressed: () => widget.store.setDefault(widget.account),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }
}
