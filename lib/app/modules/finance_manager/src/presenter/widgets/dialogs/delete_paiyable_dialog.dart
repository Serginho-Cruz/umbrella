// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_paiyable_name.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';

import '../../../domain/models/paiyable_model.dart';
import '../../../domain/states/state.dart' as s;
import '../../stores/paiyable_store.dart';
import '../../utils/currency_format.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../layout/dialog_layout.dart';
import '../texts/medium_text.dart';
import '../texts/small_text.dart';
import 'umbrella_dialogs.dart';

class DeletePaiyableDialog<T extends PaiyableModel<P>, P extends Paiyable>
    extends StatefulWidget {
  const DeletePaiyableDialog({
    super.key,
    required this.model,
    required this.store,
  });

  final T model;
  final PaiyableStore<T, P> store;

  @override
  State<DeletePaiyableDialog> createState() => _DeletePaiyableDialogState();
}

class _DeletePaiyableDialogState extends State<DeletePaiyableDialog> {
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => widget.store.state, (st) {
      var _ = switch (st) {
        s.FailState f => UmbrellaDialogs.showError(context, f.fail.message),
        s.SuccessState() => UmbrellaDialogs.showSuccess(context,
            title: 'Deleção feita',
            message:
                '${resolvePaiyableTypeName(widget.model)} deletada com sucesso.'),
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
          Align(
            alignment: Alignment.center,
            child: BigText.bold(
              'Deletar ${resolvePaiyableTypeName(widget.model)}',
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            direction: Axis.vertical,
            spacing: 25,
            children: [
              MediumText.bold('Conta: ${widget.model.account.name}'),
              MediumText.bold('Nome: ${resolvePaiyableName(widget.model)}'),
              SmallText(
                  'Valor Total: ${CurrencyFormat.format(widget.model.totalValue)}'),
              SmallText(
                  'Valor Pago: ${CurrencyFormat.format(widget.model.paidValue)}'),
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
