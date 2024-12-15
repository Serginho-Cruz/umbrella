import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/states/state.dart'
    as s;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/default_text_field.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../../domain/entities/account.dart';
import '../../stores/account_store.dart';
import '../../utils/currency_format.dart';
import '../forms/number_text_field.dart';
import '../layout/dialog_layout.dart';
import 'umbrella_dialogs.dart';

class EditAccountDialog extends StatefulWidget {
  const EditAccountDialog({
    super.key,
    required this.accountStore,
    required this.acc,
  });

  final AccountStore accountStore;
  final Account acc;

  @override
  State<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  late final ReactionDisposer _disposer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.acc.name;
    _balanceController.text = CurrencyFormat.format(widget.acc.actualBalance);

    widget.accountStore.setName(widget.acc.name);
    widget.accountStore.setBalance(widget.acc.actualBalance);

    _disposer = reaction((_) => widget.accountStore.state, (st) async {
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
            title: 'Conta Atualizada',
            message: 'Sua conta foi atualizada com sucesso!',
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
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: BigText.bold('Editar Conta'),
              ),
            ),
            Observer(
              builder: (_) => DefaultTextField(
                validator: widget.accountStore.validateName,
                controller: _nameController,
                onChanged: widget.accountStore.setName,
                onSubmitted: widget.accountStore.setName,
                labelText: 'Nome',
                readOnly: widget.accountStore.state is s.LoadingState,
                maxLength: 20,
              ),
            ),
            const SizedBox(height: 30),
            Observer(
              builder: (_) => NumberTextField(
                validate: widget.accountStore.validateBalance,
                controller: _balanceController,
                onChange: widget.accountStore.setBalance,
                isCurrency: true,
                label: 'Saldo Inicial',
                readOnly: widget.accountStore.state is s.LoadingState,
                maxLength: 9 + 4,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Observer(
                builder: (_) => PrimaryButton(
                  label: const MediumText('Atualizar'),
                  onPressed: widget.accountStore.state is s.LoadingState
                      ? () {}
                      : _update,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _update() {
    widget.accountStore.updateAccount(widget.acc);
  }

  @override
  void dispose() {
    _disposer();
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }
}
