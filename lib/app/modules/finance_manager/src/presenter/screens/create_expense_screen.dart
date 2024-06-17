import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_category_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/selectors/account_selector.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/shimmer/shimmer_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/currency_input_formatter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../utils/umbrella_palette.dart';
import '../controllers/account_controller.dart';
import '../controllers/expense_store.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/reset_button.dart';
import '../widgets/tiles/category_row.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/selectors/card_selector.dart';
import '../widgets/selectors/category_selector.dart';
import '../widgets/selectors/date_selector.dart';
import '../widgets/texts/small_text.dart';
import '../widgets/texts/text_link.dart';
import '../widgets/forms/default_text_field.dart';
import '../widgets/selectors/frequency_selector.dart';
import '../widgets/forms/number_text_field.dart';
import '../widgets/texts/medium_text.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({
    super.key,
    required CreditCardStore cardStore,
    required ExpenseStore expenseStore,
    required ExpenseCategoryStore categoryStore,
    required AccountStore accountStore,
  })  : _cardStore = cardStore,
        _expenseStore = expenseStore,
        _categoryStore = categoryStore,
        _accountStore = accountStore;

  final AccountStore _accountStore;
  final CreditCardStore _cardStore;
  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;

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
  Category? category;
  bool willBePaidWithCredit = false;
  CreditCard? cardSelected;
  bool willBeTurntIntoInstallment = false;

  String? logicalCardError;
  String? logicalCategoryError;
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
    return UmbrellaScaffold(
      appBarTitle: 'Nova Despesa',
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

                  double value =
                      double.parse(CurrencyInputFormatter.unformat(newValue));
                  setState(() {
                    parcelsValue =
                        (value / int.parse(_parcelsNumberFieldController.text))
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
                child: DateSelector(
                  initialDate: date,
                  onDateSelected: (newDate) {
                    setState(() {
                      date = newDate;
                    });
                  },
                ),
              ),
              ScopedBuilder<ExpenseCategoryStore, List<Category>>(
                store: widget._categoryStore,
                onState: (ctx, categories) => CategorySelector(
                  categories: categories,
                  onSelected: (category) {
                    setState(() {
                      category = category;
                      if (logicalCategoryError != null) {
                        logicalCategoryError = null;
                      }
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryRow(
                        category: category,
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                        ),
                      ),
                      Visibility(
                        visible: logicalCategoryError != null,
                        child: SmallText(
                          logicalCategoryError.toString(),
                          color: UmbrellaPalette.errorColor,
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
                  child: MediumText.bold('Configurações Adicionais'),
                ),
                children: [
                  ExpansionTile(
                    title: const MediumText('Despesa no Crédito'),
                    trailing: IgnorePointer(
                      child: Switch.adaptive(
                        value: willBePaidWithCredit,
                        inactiveThumbColor: Colors.black,
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.black),
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
                      const SizedBox(height: 30.0),
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
                                child: SmallText(
                                  logicalCardError.toString(),
                                  color: UmbrellaPalette.errorColor,
                                ),
                              ),
                            ],
                          );
                        },
                        onError: (ctx, error) => Container(
                          width: 275,
                          height: 150,
                          color: Colors.grey,
                          child: const MediumText(
                            'Erro ao Obter os Cartões',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onEmptyState: () => Container(
                          width: 275,
                          height: 150,
                          color: Colors.grey,
                          child: const Column(
                            children: [
                              MediumText(
                                'Nenhum Cartão Cadastrado',
                                textAlign: TextAlign.center,
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
                        title: const MediumText('Despesa Parcelada'),
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
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
                          MediumText(
                            'Valor das Parcelas: ${parcelsValue != null ? 'R\$$parcelsValue' : 'Nenhum'}.',
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
          Spaced(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05,
              vertical: 20.0,
            ),
            first: ResetButton(reset: _resetForm),
            second: PrimaryButton(
              label: const MediumText.bold('Adicionar'),
              onPressed: _onFormSubmitted,
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.black,
                size: 24.0,
              ),
            ),
          ),
        ],
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
        category: category!,
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
      category = null;
      logicalCardError = null;
      logicalCategoryError = null;
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

    if (category == null) {
      setState(() {
        logicalCategoryError = 'Uma Categoria deve ser selecionado';
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
