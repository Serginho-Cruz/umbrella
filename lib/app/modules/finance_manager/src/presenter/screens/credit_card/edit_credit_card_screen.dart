import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';

import '../../../domain/entities/credit_card.dart';
import '../../controllers/account_controller.dart';
import '../../controllers/balance_store.dart';
import '../../utils/currency_format.dart';
import '../../utils/currency_input_formatter.dart';
import '../../utils/umbrella_palette.dart';
import '../../controllers/credit_card_store.dart';
import '../../widgets/simple_information/account_name.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/others/card_preview_section.dart';
import '../../widgets/simple_information/color_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/forms/number_text_field.dart';
import '../../widgets/selectors/color_selector.dart';
import '../../widgets/selectors/day_selector.dart';
import '../../widgets/texts/medium_text.dart';

class EditCreditCardScreen extends StatefulWidget {
  const EditCreditCardScreen({
    super.key,
    required CreditCardStore cardStore,
    required AccountStore accountStore,
    required BalanceStore balanceStore,
    required CreditCard card,
  })  : _cardStore = cardStore,
        _accountStore = accountStore,
        _balanceStore = balanceStore,
        _card = card;

  final AccountStore _accountStore;
  final BalanceStore _balanceStore;
  final CreditCardStore _cardStore;
  final CreditCard _card;

  @override
  State<EditCreditCardScreen> createState() => _EditCreditCardScreenState();
}

class _EditCreditCardScreenState extends State<EditCreditCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController nameFieldController;
  late final TextEditingController annuityFieldController;

  late final FocusNode annuityFieldFocusNode;
  late final FocusNode nameFieldFocusNode;

  int invoiceCloseDay = 1;
  int invoiceDueDate = 10;

  String colorHex = '';
  String colorName = '';

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    annuityFieldController = TextEditingController();

    nameFieldFocusNode = FocusNode();
    annuityFieldFocusNode = FocusNode();

    _setVariablesToOriginal();
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    annuityFieldController.dispose();

    nameFieldFocusNode.dispose();
    annuityFieldFocusNode.dispose();
    super.dispose();
  }

  void _setVariablesToOriginal() {
    nameFieldController.text = widget._card.name;
    annuityFieldController.text = CurrencyFormat.format(widget._card.annuity);

    invoiceCloseDay = widget._card.cardInvoiceClosingDay;
    invoiceDueDate = widget._card.cardInvoiceDueDay;

    colorHex = widget._card.color;
    colorName = UmbrellaPalette.cardHexAndNames[colorHex]!;
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Editar Cartão',
        accountStore: widget._accountStore,
        balanceStore: widget._balanceStore,
      ),
      child: SingleChildScrollView(
        child: MyForm(
          formKey: formKey,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AccountName(
                account: widget._card.accountToDiscountInvoice,
                trailingText: 'Debitando da Conta',
              ),
            ),
            DefaultTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Preencha o campo Nome';
                }

                if (value.length < 5) {
                  return 'O Nome deve conter pelo menos 5 letras';
                }

                return null;
              },
              controller: nameFieldController,
              focusNode: nameFieldFocusNode,
              maxLength: 30,
              labelText: 'Nome',
              onEditingComplete: () {
                nameFieldFocusNode.unfocus();
                setState(() {});
              },
            ),
            NumberTextField(
              controller: annuityFieldController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              isCurrency: true,
              label: 'Anuidade do Cartão',
              focusNode: annuityFieldFocusNode,
              validate: (number) => null,
            ),
            DaySelector(
              bottomSheetText:
                  'Selecione o Dia do Fechamento da fatura desse cartão',
              onDaySelected: (day) {
                setState(() => invoiceCloseDay = day);
              },
              child: Spaced(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                first: const BigText('Fecham. da Fatura'),
                second: BigText('Dia $invoiceCloseDay'),
              ),
            ),
            DaySelector(
              bottomSheetText:
                  'Selecione o Dia do Vencimento da fatura desse cartão',
              onDaySelected: (day) {
                setState(() => invoiceDueDate = day);
              },
              child: Spaced(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                first: const BigText('Vencim. da Fatura'),
                second: BigText('Dia $invoiceDueDate'),
              ),
            ),
            ColorSelector(
              onSelected: (hex) {
                setState(() {
                  colorHex = hex;
                  colorName = UmbrellaPalette.cardHexAndNames[hex]!;
                });
              },
              child: ColorRow(
                colorName: colorName,
                colorHex: colorHex,
                label: 'Cor do Cartão',
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            CardPreviewSection(
              card: _mountCard(),
              isToShow: nameFieldController.text.trim().isNotEmpty,
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              first: ResetButton(
                reset: _resetForm,
                label: const MediumText.bold('Reiniciar'),
              ),
              second: PrimaryButton(
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const MediumText.bold('Atualizar'),
                onPressed: _onFormSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    var (isValid, error) = _validateForm();

    if (!isValid) {
      UmbrellaDialogs.showError(context, error);
      return;
    }

    var card = _mountCard();

    widget._cardStore.updateCard(widget._card, card).then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Cartão Atualizado',
          message: 'Seu Cartão de Crédito foi atualizado com sucesso.',
        ).then((_) {
          Navigator.pop(context);
        });
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }

  (bool, String) _validateForm() {
    bool areFieldsValid = formKey.currentState!.validate();

    if (!areFieldsValid) {
      return (
        false,
        'Parece que o formulário contém erros. Corrija-os e tente denovo'
      );
    }
    if (invoiceCloseDay == invoiceDueDate) {
      return (false, 'A Fatura não pode fechar no mesmo dia do vencimento');
    }

    return (true, '');
  }

  void _resetForm() {
    setState(_setVariablesToOriginal);
  }

  CreditCard _mountCard() {
    String name = nameFieldController.text.trim();

    String annuityText =
        CurrencyInputFormatter.unformat(annuityFieldController.text);

    return CreditCard(
      id: widget._card.id,
      name: name,
      accountToDiscountInvoice: widget._card.accountToDiscountInvoice,
      annuity: double.parse(annuityText),
      cardInvoiceClosingDay: invoiceCloseDay,
      cardInvoiceDueDay: invoiceDueDate,
      color: colorHex,
    );
  }
}
