import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/credit_card.dart';
import '../../../domain/states/state.dart' as s;
import '../../stores/credit_card_store.dart';
import '../../utils/loading_animation_type.dart';
import '../../utils/umbrella_palette.dart';
import '../../stores/account_store.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/dialogs/loading_dialog.dart';
import '../../widgets/others/card_preview_section.dart';
import '../../widgets/simple_information/color_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/selectors/color_selector.dart';
import '../../widgets/selectors/day_selector.dart';
import '../../widgets/texts/medium_text.dart';

class CreateCreditCardScreen extends StatefulWidget {
  const CreateCreditCardScreen({
    super.key,
    required AccountStore accountStore,
    required CreditCardStore cardStore,
  })  : _accountStore = accountStore,
        _cardStore = cardStore;

  final AccountStore _accountStore;
  final CreditCardStore _cardStore;

  @override
  State<CreateCreditCardScreen> createState() => _CreateCreditCardScreenState();
}

class _CreateCreditCardScreenState extends State<CreateCreditCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final ReactionDisposer _disposer;

  bool _isLoading = false;

  void _setUpReaction() {
    _disposer = reaction(
      (_) => widget._cardStore.state,
      (st) async {
        switch (st) {
          case s.LoadingState():
            _isLoading = true;
            LoadingDialog.show(
              context,
              message: 'Criando seu novo cartão...',
              type: LoadingAnimationType.create,
            );
            break;
          case s.SuccessState():
            if (_isLoading) Navigator.pop(context);
            _isLoading = false;
            await UmbrellaDialogs.showSuccess(
              context,
              title: 'Cartão Cadastrado',
              message:
                  'Seu Cartão de Crédito foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Anterior',
            );
            _disposer();

            if (mounted) Navigator.pop(context);
            break;
          case s.FailState f:
            if (_isLoading) Navigator.pop(context);
            _isLoading = false;
            await UmbrellaDialogs.showError(context, f.fail.message);
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    var first = UmbrellaPalette.cardHexAndNames.keys.first;
    widget._cardStore.setColor(first);
    _setUpReaction();
  }

  @override
  void dispose() {
    widget._cardStore.resetFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Novo Cartão',
      ),
      child: SingleChildScrollView(
        child: MyForm(
          formKey: formKey,
          padding: EdgeInsets.only(
            top: 12.0,
            left: MediaQuery.sizeOf(context).width * 0.05,
            right: MediaQuery.sizeOf(context).width * 0.05,
          ),
          children: [
            Observer(
              builder: (_) => ListSegmentedStateWidget(
                state: widget._accountStore.state,
                onLoading: (_) => const CircularProgressIndicator.adaptive(),
                onFail: (ctx, fail) => Text(fail.message),
                onEmpty: (_) => Container(),
                onState: (ctx, accounts) {
                  Account acc = accounts.firstWhere((ac) => ac.isDefault);

                  widget._cardStore.setAccount(acc);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: AccountSelector(
                      accounts: accounts,
                      selectedAccount: widget._cardStore.account,
                      label: 'Conta a debitar',
                      onSelected: widget._cardStore.setAccount,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Observer(
                builder: (_) => DefaultTextField(
                  validator: widget._cardStore.validateName,
                  maxLength: 30,
                  labelText: 'Nome',
                  onChanged: widget._cardStore.setName,
                  readOnly: widget._cardStore.isLoading,
                ),
              ),
            ),
            Observer(builder: (_) {
              return DaySelector(
                bottomSheetText:
                    'Selecione o Dia do Fechamento da fatura desse cartão',
                onDaySelected: widget._cardStore.setCloseDay,
                child: Spaced(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  first: const BigText('Fecham. da Fatura'),
                  second: BigText('Dia ${widget._cardStore.invoiceCloseDay}'),
                ),
              );
            }),
            Observer(builder: (_) {
              return DaySelector(
                bottomSheetText:
                    'Selecione o Dia do Vencimento da fatura desse cartão',
                onDaySelected: widget._cardStore.setDueDay,
                child: Spaced(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  first: const BigText('Vencim. da Fatura'),
                  second: BigText('Dia ${widget._cardStore.invoiceDueDay}'),
                ),
              );
            }),
            Observer(
              builder: (_) {
                String hex = widget._cardStore.color;
                return ColorSelector(
                  onSelected: widget._cardStore.setColor,
                  child: ColorRow(
                    colorHex: widget._cardStore.color,
                    colorName: UmbrellaPalette.cardHexAndNames[hex] ?? "",
                    label: 'Cor do Cartão',
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                );
              },
            ),
            Observer(
              builder: (_) => CardPreviewSection(
                card: _mountCard(),
                isToShow: widget._cardStore.showPreview,
              ),
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              first: SecondaryButton(onPressed: resetForm),
              second: PrimaryButton(
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const MediumText.bold('Adicionar'),
                onPressed: onFormSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CreditCard _mountCard() {
    return CreditCard(
      id: '',
      name: widget._cardStore.name,
      accountToDiscountInvoice: widget._cardStore.account!,
      cardInvoiceClosingDay: widget._cardStore.invoiceCloseDay,
      cardInvoiceDueDay: widget._cardStore.invoiceDueDay,
      color: widget._cardStore.color,
    );
  }

  void onFormSubmitted() async {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      UmbrellaDialogs.showError(context,
          'O formulário contém erros. Corrija-os para cadastrar seu cartão');
      return;
    }

    widget._cardStore.register();
  }

  void resetForm() {
    String hex = UmbrellaPalette.cardHexAndNames.keys.first;
    widget._cardStore
      ..resetFields()
      ..setColor(hex);
  }
}
