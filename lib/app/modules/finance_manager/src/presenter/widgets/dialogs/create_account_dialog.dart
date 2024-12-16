import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/states/state.dart'
    as s;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/default_text_field.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/loading_animation_crossfade.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../stores/account_store.dart';
import '../../utils/loading_animation_type.dart';
import '../forms/number_text_field.dart';
import '../layout/dialog_layout.dart';
import 'umbrella_dialogs.dart';

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key, required this.accountStore});

  final AccountStore accountStore;

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController =
      TextEditingController(text: 'R\$ 0,00');

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => widget.accountStore.state, (st) async {
      switch (st) {
        case s.SuccessState():
          await UmbrellaDialogs.showSuccess(
            context,
            title: 'Conta Criada',
            message: 'Sua nova conta foi criada com sucesso!',
          );
          if (mounted) Navigator.pop(context);

          break;
        case s.FailState failState:
          UmbrellaDialogs.showError(context, failState.fail.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.8;

    return DialogLayout(
      child: Observer(
        builder: (_) => LoadingAnimationCrossfade(
          state: widget.accountStore.state,
          animationWidth: width - 50,
          animationHeight: 400,
          animationText: 'Criando sua nova conta...',
          type: LoadingAnimationType.create,
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: BigText.bold('Criar Conta'),
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
                    maxLength: 8,
                  ),
                ),
                const SizedBox(height: 30),
                Observer(
                  builder: (_) => PrimaryButton(
                    label: const MediumText('Criar'),
                    onPressed: widget.accountStore.state is s.LoadingState
                        ? () {}
                        : widget.accountStore.create,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposer();
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }
}
