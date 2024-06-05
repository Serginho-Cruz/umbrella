import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_type_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/app_bar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/button_with_icon.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/my_drawer.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/selectors/base_selectors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/account_selector.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/spaced_widgets.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/shimmer/shimmer_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/currency_input_formatter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../controllers/account_controller.dart';
import '../controllers/expense_store.dart';
import '../widgets/selectors/card_selector.dart';
import '../widgets/forms/date_picker.dart';
import '../widgets/common/text_link.dart';
import '../widgets/forms/default_text_field.dart';
import '../widgets/selectors/frequency_selector.dart';
import '../widgets/forms/number_text_field.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({
    super.key,
    required CreditCardStore cardStore,
    required ExpenseStore expenseStore,
    required ExpenseTypeStore typeStore,
    required AccountStore accountStore,
  })  : _cardStore = cardStore,
        _expenseStore = expenseStore,
        _typeStore = typeStore,
        _accountStore = accountStore;

  final AccountStore _accountStore;
  final CreditCardStore _cardStore;
  final ExpenseStore _expenseStore;
  final ExpenseTypeStore _typeStore;

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameFieldController;
  late final TextEditingController _valueFieldController;
  late final TextEditingController _parcelsNumberFieldController;

  late final TextEditingController _personNameFieldController;

  late final FocusNode _nameFieldFocusNode;
  late final FocusNode _valueFieldFocusNode;
  late final FocusNode _parcelsNumberFieldFocusNode;
  late final FocusNode _personNameFocusNode;

  Account? account;
  Frequency frequency = Frequency.none;
  Date date = Date.today();
  ExpenseType? expenseType;
  bool willBePaidWithCredit = false;
  CreditCard? cardSelected;
  bool willBeTurntIntoInstallment = false;

  String? logicalCardError;
  String? logicalTypeError;
  double? parcelsValue;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _nameFieldController = TextEditingController();
    _valueFieldController = TextEditingController(text: 'R\$0,00');
    _parcelsNumberFieldController = TextEditingController();
    _personNameFieldController = TextEditingController();

    _nameFieldFocusNode = FocusNode();
    _valueFieldFocusNode = FocusNode();
    _parcelsNumberFieldFocusNode = FocusNode();
    _personNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _valueFieldController.dispose();
    _personNameFieldController.dispose();
    _parcelsNumberFieldController.dispose();

    _nameFieldFocusNode.dispose();
    _valueFieldFocusNode.dispose();
    _parcelsNumberFieldFocusNode.dispose();
    _personNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: 'Nova Despesa'),
              MyForm(
                formKey: _formKey,
                padding: const EdgeInsets.only(top: 12.0),
                width: MediaQuery.of(context).size.width * 0.9,
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
                  ),
                  NumberTextField(
                    controller: _valueFieldController,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    isCurrency: true,
                    label: 'Valor',
                    initialValue: 0.00,
                    focusNode: _valueFieldFocusNode,
                    validate: (number) {
                      if (number == 0.00) {
                        return 'O Valor deve ser maior que 0';
                      }

                      return null;
                    },
                    onChange: (newValue) {
                      if (!willBeTurntIntoInstallment) return;

                      if (newValue == null ||
                          newValue.isEmpty ||
                          _parcelsNumberFieldController.text.isEmpty) {
                        setState(() => parcelsValue = null);
                        return;
                      }

                      double value = double.parse(
                          CurrencyInputFormatter.unformat(newValue));
                      setState(() {
                        parcelsValue = (value /
                                int.parse(_parcelsNumberFieldController.text))
                            .roundToDecimal();
                      });
                    },
                  ),
                  FrequencySelector(
                    title: 'Qual a Frequência dessa Despesa?',
                    selectedFrequency: frequency,
                    onSelected: (newFrequency) {
                      setState(() {
                        frequency = newFrequency;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: DatePicker(
                      initialDate: date,
                      onDateSelected: (newDate) {
                        setState(() {
                          date = newDate;
                        });
                      },
                    ),
                  ),
                  ScopedBuilder<ExpenseTypeStore, List<ExpenseType>>(
                    store: widget._typeStore,
                    onState: (ctx, types) => GridSelector<ExpenseType>(
                      items: types,
                      itemsPerLine: 3,
                      linesGap: 20.0,
                      itemSize: 80.0,
                      itemBuilder: (type) {
                        return LimitedBox(
                          maxWidth: 80.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/${type.icon}',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                type.name,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: UmbrellaSizes.small,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onItemTap: (type) {
                        setState(() {
                          expenseType = type;
                          if (logicalTypeError != null) {
                            logicalTypeError = null;
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SpacedWidgets(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            first: const Text(
                              "Tipo",
                              style: TextStyle(fontSize: UmbrellaSizes.big),
                            ),
                            second: Row(
                              children: [
                                Text(
                                  expenseType?.name ?? 'Indefinido',
                                  style: const TextStyle(
                                    fontSize: UmbrellaSizes.medium,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  height: 36.0,
                                  width: 36.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        expenseType == null
                                            ? 'assets/icons/undefined.png'
                                            : 'assets/${expenseType!.icon}',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: logicalTypeError != null,
                            child: Text(
                              logicalTypeError.toString(),
                              style: const TextStyle(
                                fontSize: UmbrellaSizes.small,
                                color: UmbrellaPalette.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onError: (context, e) {
                      Fail error = e;
                      return Text(error.message);
                    },
                    onLoading: (context) =>
                        const CircularProgressIndicator.adaptive(),
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.transparent,
                    maintainState: true,
                    title: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Configurações Adicionais',
                        style: TextStyle(
                          fontSize: UmbrellaSizes.medium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      ExpansionTile(
                        title: const Text(
                          'Despesa no Crédito',
                          style: TextStyle(fontSize: UmbrellaSizes.medium),
                        ),
                        trailing: IgnorePointer(
                          child: Switch.adaptive(
                            value: willBePaidWithCredit,
                            inactiveThumbColor: Colors.black,
                            trackOutlineColor:
                                const MaterialStatePropertyAll(Colors.black),
                            inactiveTrackColor: UmbrellaPalette.gray,
                            activeColor: Colors.white,
                            activeTrackColor: UmbrellaPalette.secondaryColor,
                            onChanged: (_) {},
                          ),
                        ),
                        onExpansionChanged: (newValue) {
                          setState(() {
                            willBePaidWithCredit = newValue;
                            cardSelected = null;
                          });
                        },
                        children: [
                          const SizedBox(
                            height: 30.0,
                          ),
                          ListScopedBuilder<CreditCardStore, List<CreditCard>>(
                            store: widget._cardStore,
                            loadingWidget: const Stack(
                              children: [
                                ShimmerContainer(
                                  width: 275,
                                  height: 150,
                                ),
                                Text('Obtendo Cartões...'),
                              ],
                            ),
                            onState: (ctx, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CardSelector(
                                    cardSelected: cardSelected,
                                    cards: state,
                                    onCardSelected: (card) {
                                      setState(() {
                                        cardSelected = card;
                                        if (logicalCardError != null) {
                                          logicalCardError = null;
                                        }
                                      });
                                    },
                                  ),
                                  Visibility(
                                    visible: logicalCardError != null,
                                    child: Text(
                                      logicalCardError.toString(),
                                      style: const TextStyle(
                                        fontSize: UmbrellaSizes.small,
                                        color: UmbrellaPalette.errorColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            onError: (ctx, error) => Container(
                              width: 275,
                              height: 150,
                              color: Colors.grey,
                              child: const Text(
                                'Erro ao Obter os Cartões',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: UmbrellaSizes.medium,
                                ),
                              ),
                            ),
                            onEmptyState: () => Container(
                              width: 275,
                              height: 150,
                              color: Colors.grey,
                              child: const Column(
                                children: [
                                  Text(
                                    'Nenhum Cartão Cadastrado',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  TextLink(
                                    route: '/finance_manager/home',
                                    text: 'Cadastre um Agora',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ExpansionTile(
                            title: const Text(
                              'Despesa Parcelada',
                              style: TextStyle(
                                fontSize: UmbrellaSizes.medium,
                              ),
                            ),
                            trailing: Transform.scale(
                              scale: 1.2,
                              child: IgnorePointer(
                                child: Checkbox.adaptive(
                                  value: willBeTurntIntoInstallment,
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                            onExpansionChanged: (newValue) {
                              setState(() {
                                willBeTurntIntoInstallment = newValue;
                              });

                              if (newValue == false) {
                                _parcelsNumberFieldController.clear();
                              }
                            },
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              NumberTextField(
                                controller: _parcelsNumberFieldController,
                                padding: const EdgeInsets.only(top: 8.0),
                                validate: (number) {
                                  if (number > 100) {
                                    return 'O Máximo de Parcelas é 100';
                                  }

                                  return null;
                                },
                                onChange: (parcelsNumber) {
                                  if (parcelsNumber == null ||
                                      parcelsNumber.isEmpty ||
                                      _valueFieldController.text.isEmpty) {
                                    setState(() => parcelsValue = null);
                                    return;
                                  }

                                  double value = double.parse(
                                      CurrencyInputFormatter.unformat(
                                          _valueFieldController.text));
                                  setState(() {
                                    parcelsValue =
                                        (value / int.parse(parcelsNumber))
                                            .roundToDecimal();
                                  });
                                },
                                label: 'Nº de Parcelas',
                                maxLength: 3,
                                focusNode: _parcelsNumberFieldFocusNode,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'Valor das Parcelas: ${parcelsValue != null ? 'R\$$parcelsValue' : 'Nenhum'}.',
                                style: const TextStyle(
                                  fontSize: UmbrellaSizes.medium,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ],
                      ),
                      DefaultTextField(
                        height: 70.0,
                        controller: _personNameFieldController,
                        focusNode: _personNameFocusNode,
                        labelText: 'A Quem você deve isso? (Opcional)',
                        maxLength: 20,
                        validator: (_) => null,
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                    ],
                  ),
                ],
              ),
              SpacedWidgets(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05,
                  vertical: 20.0,
                ),
                first: ButtonWithIcon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh_rounded, size: 24.0),
                  color: Colors.yellow,
                  text: 'Limpar',
                ),
                second: ButtonWithIcon(
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  color: const Color(0xFFCD8CFF),
                  text: 'Adicionar',
                  onPressed: _onFormSubmitted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    var (isFormValid, message) = _validateForm();

    if (!isFormValid) {
      UmbrellaDialogs.showError(
          context,
          message ??
              'Parece que o formulário contém erros. Corrija-os e tente denovo');
      return;
    }

    String totalValueStr =
        CurrencyInputFormatter.unformat(_valueFieldController.text);

    Expense newExpense = Expense(
        id: 0,
        name: _nameFieldController.text,
        totalValue: double.parse(totalValueStr),
        paidValue: 0.00,
        remainingValue: double.parse(totalValueStr),
        dueDate: date,
        type: expenseType!,
        frequency: frequency,
        personName: _personNameFieldController.text.trim().isEmpty
            ? null
            : _personNameFieldController.text.trim());

    //TODO: Put logic to pay in credit or in installments
    widget._expenseStore.register(newExpense, account!).then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Despesa Cadastrada',
          message:
              'Sua despesa foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Principal',
        );
        Navigator.pushReplacementNamed(context, '/finance_manager/');
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }

  void _resetForm() {
    setState(() {
      _nameFieldController.clear();
      _valueFieldController.clear();
      _parcelsNumberFieldController.clear();
      _personNameFieldController.clear();
      frequency = Frequency.none;
      date = Date.today();
      expenseType = null;
      logicalCardError = null;
      logicalTypeError = null;
      willBePaidWithCredit = false;
      cardSelected = null;
      willBeTurntIntoInstallment = false;
    });
  }

  (bool, String? message) _validateForm() {
    bool areFieldsValid = _formKey.currentState!.validate();

    if (!areFieldsValid) return (false, null);

    if (account == null) {
      return (
        false,
        'Por favor, selecione a conta onde a despesa será debitada'
      );
    }

    if (expenseType == null) {
      setState(() {
        logicalTypeError = 'Um Tipo de Despesa deve ser selecionado';
      });
      return (false, null);
    }

    if (willBePaidWithCredit && cardSelected == null) {
      setState(() {
        logicalCardError =
            'O Cartão que será usado no pagamento deve ser colocado';
      });
      return (false, null);
    }

    return (true, null);
  }
}
