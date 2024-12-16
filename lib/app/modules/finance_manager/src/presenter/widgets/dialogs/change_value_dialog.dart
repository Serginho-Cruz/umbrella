import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/loading_animation_crossfade.dart';
import '../../../domain/entities/paiyable.dart';
import '../../../domain/models/paiyable_model.dart';
import '../../../domain/states/state.dart' as s;
import '../../stores/paiyable_store.dart';
import '../../utils/resolve_paiyable_name.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../forms/my_form.dart';
import '../forms/number_text_field.dart';
import '../layout/dialog_layout.dart';
import '../layout/spaced.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import '../texts/title_text.dart';
import 'umbrella_dialogs.dart';

class ChangeValueDialog<P extends PaiyableModel<T>, T extends Paiyable>
    extends StatefulWidget {
  const ChangeValueDialog({
    super.key,
    required this.store,
    required this.model,
  });

  final P model;
  final PaiyableStore<P, T> store;

  @override
  State<ChangeValueDialog> createState() => _ChangeValueDialogState();
}

class _ChangeValueDialogState extends State<ChangeValueDialog> {
  late final FocusNode focusNode;
  final GlobalKey<FormState> formKey = GlobalKey();
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _disposer = reaction((_) => widget.store.state, (st) {
      switch (st) {
        case s.FailState f:
          UmbrellaDialogs.showError(context, f.fail.message);
          break;
        case s.SuccessState():
          UmbrellaDialogs.showSuccess(
            context,
            title: 'Valor alterado',
            message:
                'O valor total da sua ${resolvePaiyableTypeName(widget.model)} foi alterado com sucesso',
          );
      }
    });
  }

  @override
  void dispose() {
    _disposer();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: LoadingAnimationCrossfade(
        state: widget.store.state,
        animationHeight: 300,
        animationWidth: MediaQuery.sizeOf(context).width * 0.8,
        animationText: 'Atualizando ${resolvePaiyableTypeName(widget.model)}',
        child: MyForm(
          formKey: formKey,
          verticalSize: MainAxisSize.min,
          padding: const EdgeInsets.all(15.0),
          children: [
            const Align(child: TitleText.bold('Alterar Valor')),
            const SizedBox(height: 40.0),
            Row(
              children: [
                MediumText('${resolvePaiyableTypeName(widget.model)}:'),
                const SizedBox(width: 10.0),
                MediumText.bold(resolvePaiyableName(widget.model)),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const MediumText('Valor Total:'),
                const SizedBox(width: 10.0),
                Price.medium(
                  widget.model.totalValue,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            NumberTextField(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              isCurrency: true,
              label: 'Novo Valor',
              initialValue: 0.00,
              focusNode: focusNode,
              onChange: widget.store.setValue,
              validate: widget.store.validateValue,
            ),
            Spaced(
              first: SecondaryButton(
                width: MediaQuery.sizeOf(context).width * 0.25,
                label: const MediumText.bold('Voltar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              second: PrimaryButton(
                width: MediaQuery.sizeOf(context).width * 0.4,
                icon: const Icon(
                  Icons.edit_square,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const MediumText.bold('Alterar'),
                onPressed: alterValue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void alterValue() {
    widget.store.updateValue().then((error) {
      if (!mounted) return;
      error != null
          ? UmbrellaDialogs.showError(
              context,
              error.message,
              onRetry: alterValue,
              onConfirmPressed: () => Navigator.pop(context),
            )
          : Navigator.pop(context);
    });
  }
}
