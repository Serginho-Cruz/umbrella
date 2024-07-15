import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/credit_card.dart';
import '../../controllers/balance_store.dart';
import '../../utils/currency_input_formatter.dart';
import '../../utils/umbrella_palette.dart';
import '../../controllers/account_controller.dart';
import '../../controllers/credit_card_store.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/others/card_preview_section.dart';
import '../../widgets/simple_information/color_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/forms/number_text_field.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/selectors/color_selector.dart';
import '../../widgets/selectors/day_selector.dart';
import '../../widgets/texts/medium_text.dart';

class CreateCreditCardScreen extends StatefulWidget {
  const CreateCreditCardScreen({
    super.key,
    required AccountStore accountStore,
    required BalanceStore balanceStore,
    required CreditCardStore cardStore,
  })  : _accountStore = accountStore,
        _balanceStore = balanceStore,
        _cardStore = cardStore;

  final AccountStore _accountStore;
  final BalanceStore _balanceStore;
  final CreditCardStore _cardStore;

  @override
  State<CreateCreditCardScreen> createState() => _CreateCreditCardScreenState();
}

class _CreateCreditCardScreenState extends State<CreateCreditCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController nameFieldController;
  late final TextEditingController annuityFieldController;

  late final FocusNode annuityFocusNode;
  late final FocusNode nameFieldFocusNode;

  Account? account;
  int invoiceCloseDay = 1;
  int invoiceDueDate = 10;

  String hexColor = '';
  String colorName = '';

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    annuityFieldController = TextEditingController(text: 'R\$ 0,00');

    nameFieldFocusNode = FocusNode();
    annuityFocusNode = FocusNode();

    var first = UmbrellaPalette.cardHexAndNames.keys.first;
    hexColor = first;
    colorName = UmbrellaPalette.cardHexAndNames[first]!;
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    annuityFieldController.dispose();

    nameFieldFocusNode.dispose();
    annuityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Novo Cartão',
        accountStore: widget._accountStore,
        balanceStore: widget._balanceStore,
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
            ListScopedBuilder<AccountStore, List<Account>>(
              store: widget._accountStore,
              loadingWidget: const CircularProgressIndicator.adaptive(),
              onError: (ctx, fail) => Text(fail.message),
              onEmptyState: () => Container(),
              onState: (ctx, accounts) {
                account =
                    account ?? accounts.singleWhere((acc) => acc.isDefault);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: AccountSelector(
                    accounts: accounts,
                    selectedAccount: account!,
                    label: 'Conta a debitar',
                    onSelected: (acc) {
                      setState(() {
                        account = acc;
                      });
                    },
                  ),
                );
              },
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
              },
            ),
            NumberTextField(
              controller: annuityFieldController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              isCurrency: true,
              label: 'Anuidade do Cartão',
              focusNode: annuityFocusNode,
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
                  hexColor = hex;
                  colorName = UmbrellaPalette.cardHexAndNames[hex]!;
                });
              },
              child: ColorRow(
                colorHex: hexColor,
                colorName: colorName,
                label: 'Cor do Cartão',
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            CardPreviewSection(
              card: mountCard(),
              isToShow: nameFieldController.text.trim().isNotEmpty,
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              first: ResetButton(reset: resetForm),
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

  CreditCard mountCard() {
    String name = nameFieldController.text.trim();
    String annuityText =
        CurrencyInputFormatter.unformat(annuityFieldController.text);

    return CreditCard(
      id: 0,
      name: name,
      accountToDiscountInvoice: account!,
      annuity: double.parse(annuityText),
      cardInvoiceClosingDay: invoiceCloseDay,
      cardInvoiceDueDay: invoiceDueDate,
      color: hexColor,
    );
  }

  void onFormSubmitted() {
    var (isValid, error) = validateForm();

    if (!isValid) {
      UmbrellaDialogs.showError(context, error);
      return;
    }

    String annuityStr =
        CurrencyInputFormatter.unformat(annuityFieldController.text);

    CreditCard card = CreditCard(
      id: 0,
      accountToDiscountInvoice: account!,
      name: nameFieldController.text,
      annuity: double.parse(annuityStr),
      color: hexColor,
      cardInvoiceClosingDay: invoiceCloseDay,
      cardInvoiceDueDay: invoiceDueDate,
    );

    widget._cardStore.register(card).then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Cartão Cadastrado',
          message:
              'Seu Cartão de Crédito foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Principal',
        ).then((_) {
          Navigator.pushReplacementNamed(context, '/finance_manager/');
        });
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }

  (bool, String) validateForm() {
    bool areFieldsValid = formKey.currentState!.validate();

    if (!areFieldsValid) {
      return (
        false,
        'Parece que o formulário contém erros. Corrija-os e tente denovo'
      );
    }

    if (account == null) {
      return (false, 'Uma conta precisa ser selecionada');
    }

    if (invoiceCloseDay == invoiceDueDate) {
      return (false, 'A Fatura não pode fechar no mesmo dia do vencimento');
    }

    return (true, '');
  }

  void resetForm() {
    String hex = UmbrellaPalette.cardHexAndNames.keys.first;
    String name = UmbrellaPalette.cardHexAndNames[hex]!;

    setState(() {
      nameFieldController.clear();
      annuityFieldController.text = 'R\$ 0,00';
      invoiceCloseDay = 1;
      invoiceDueDate = 10;
      hexColor = hex;
      colorName = name;
    });
  }
}
