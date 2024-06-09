import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/credit_card.dart';
import '../../utils/currency_input_formatter.dart';
import '../../utils/hex_color.dart';
import '../../utils/umbrella_palette.dart';
import '../controllers/account_controller.dart';
import '../controllers/credit_card_store.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/reset_button.dart';
import '../widgets/my_drawer.dart';
import '../widgets/layout/spaced.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/umbrella_dialogs.dart';
import '../widgets/cards/credit_card_widget.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/forms/default_text_field.dart';
import '../widgets/forms/my_form.dart';
import '../widgets/forms/number_text_field.dart';
import '../widgets/list_scoped_builder.dart';
import '../widgets/selectors/color_selector.dart';
import '../widgets/selectors/day_selector.dart';
import '../widgets/texts/medium_text.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _nameFieldController;
  late final TextEditingController _annuityFieldController;

  late final FocusNode _annuityFocusNode;
  late final FocusNode _nameFieldFocusNode;

  Account? account;
  int invoiceCloseDay = 1;
  int invoiceDueDate = 10;

  String hexColor = '';
  String colorName = '';

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController();
    _annuityFieldController = TextEditingController(text: 'R\$ 0,00');

    _nameFieldFocusNode = FocusNode();
    _annuityFocusNode = FocusNode();

    var first = UmbrellaPalette.cardColorsHexAndNames.first;
    hexColor = first.$1;
    colorName = first.$2;
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _annuityFieldController.dispose();

    _nameFieldFocusNode.dispose();
    _annuityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: CustomAppBar(title: 'Novo Cartão'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MyForm(
                formKey: _formKey,
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
                      account = account ??
                          accounts.singleWhere((acc) => acc.isDefault);

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
                    controller: _nameFieldController,
                    focusNode: _nameFieldFocusNode,
                    maxLength: 30,
                    labelText: 'Nome',
                    onEditingComplete: () {
                      _nameFieldFocusNode.unfocus();
                      _annuityFocusNode.requestFocus();
                    },
                  ),
                  NumberTextField(
                    controller: _annuityFieldController,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    isCurrency: true,
                    label: 'Anuidade do Cartão',
                    focusNode: _annuityFocusNode,
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
                    onSelected: (hexAndName) {
                      setState(() {
                        hexColor = hexAndName.$1;
                        colorName = hexAndName.$2;
                      });
                    },
                    child: Spaced(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      first: const BigText('Cor do Cartão'),
                      second: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediumText(colorName),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            margin: const EdgeInsets.only(left: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: HexColor(hexColor),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _makePreviewSection(),
                  Spaced(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    first: ResetButton(reset: _resetForm),
                    second: PrimaryButton(
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      label: const MediumText.bold('Adicionar'),
                      onPressed: _onFormSubmitted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _makePreviewSection() {
    String name = _nameFieldController.text.trim();
    if (account == null || name.isEmpty) return const SizedBox.shrink();

    String annuityText =
        CurrencyInputFormatter.unformat(_annuityFieldController.text);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: BigText('Pré-visualização'),
        ),
        CreditCardWidget(
          margin: const EdgeInsets.symmetric(vertical: 25.0),
          creditCard: CreditCard(
            accountToDiscountInvoice: account!,
            annuity: double.parse(annuityText),
            cardInvoiceClosingDay: invoiceCloseDay,
            cardInvoiceDueDay: invoiceDueDate,
            id: 0,
            color: hexColor,
            name: _nameFieldController.text,
          ),
        ),
      ],
    );
  }

  void _onFormSubmitted() {
    var (isValid, error) = _validateForm();

    if (!isValid) {
      UmbrellaDialogs.showError(context, error);
      return;
    }

    String annuityStr =
        CurrencyInputFormatter.unformat(_annuityFieldController.text);

    CreditCard card = CreditCard(
      id: 0,
      accountToDiscountInvoice: account!,
      name: _nameFieldController.text,
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
        );
        Navigator.pushReplacementNamed(context, '/finance_manager/');
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }

  (bool, String) _validateForm() {
    bool areFieldsValid = _formKey.currentState!.validate();

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

  void _resetForm() {
    var (hex, name) = UmbrellaPalette.cardColorsHexAndNames.first;

    setState(() {
      _nameFieldController.clear();
      _annuityFieldController.text = 'R\$ 0,00';
      invoiceCloseDay = 1;
      invoiceDueDate = 10;
      hexColor = hex;
      colorName = name;
    });
  }
}
