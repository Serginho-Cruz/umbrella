// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';

import '../../../domain/entities/credit_card.dart';
import '../../../domain/states/state.dart' as s;
import '../../stores/credit_card_store.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../layout/dialog_layout.dart';
import '../texts/medium_text.dart';
import 'umbrella_dialogs.dart';

class DeleteCardDialog extends StatefulWidget {
  const DeleteCardDialog({
    super.key,
    required this.card,
    required this.store,
  });

  final CreditCard card;
  final CreditCardStore store;

  @override
  State<DeleteCardDialog> createState() => _DeleteCardDialogState();
}

class _DeleteCardDialogState extends State<DeleteCardDialog> {
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => widget.store.state, (st) {
      var _ = switch (st) {
        s.FailState f => UmbrellaDialogs.showError(context, f.fail.message),
        s.SuccessState() => UmbrellaDialogs.showSuccess(context,
            title: 'Deleção feita', message: 'Cartão deletado com sucesso.'),
        _ => null,
      };
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
            child: BigText.bold('Deletar Cartão'),
          ),
          const SizedBox(height: 30),
          Wrap(
            direction: Axis.vertical,
            spacing: 25,
            children: [
              MediumText('Conta: ${widget.card.accountToDiscountInvoice.name}'),
              MediumText('Nome: ${widget.card.name}'),
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
                onPressed: () async {
                  widget.store.delete().then((fail) {
                    if (fail == null) Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
