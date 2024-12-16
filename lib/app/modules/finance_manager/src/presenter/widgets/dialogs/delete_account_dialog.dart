import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/loading_animation_crossfade.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/states/state.dart' as s;
import '../../utils/currency_format.dart';
import '../../utils/loading_animation_type.dart';
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

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => widget.store.state, (st) async {
      switch (st) {
        case s.FailState f:
          UmbrellaDialogs.showError(context, f.fail.message);
          break;
        case s.SuccessState():
          await UmbrellaDialogs.showSuccess(
            context,
            title: 'Deleção feita',
            message: 'Conta deletada com sucesso.',
          );
          if (mounted) Navigator.pop(context);
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
      child: Observer(
        builder: (_) => LoadingAnimationCrossfade(
          state: widget.store.state,
          type: LoadingAnimationType.erase,
          animationWidth: MediaQuery.sizeOf(context).width * 0.8 - 50,
          animationHeight: 400,
          animationText: 'Deletando Conta...',
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
        ),
      ),
    );
  }
}
