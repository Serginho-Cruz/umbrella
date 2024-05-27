import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/income_type.dart';
import '../../errors/errors.dart';
import '../../utils/currency_input_formatter.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../controllers/account_controller.dart';
import '../controllers/income_store.dart';
import '../controllers/income_type_store.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/common/button_with_icon.dart';
import '../widgets/common/date_picker.dart';
import '../widgets/common/my_drawer.dart';
import '../widgets/common/selectors.dart';
import '../widgets/common/spaced_widgets.dart';
import '../widgets/common/umbrella_dialogs.dart';
import '../widgets/forms/account_selector.dart';
import '../widgets/forms/default_text_field.dart';
import '../widgets/forms/frequency_selector.dart';
import '../widgets/forms/my_form.dart';
import '../widgets/forms/number_text_field.dart';
import '../widgets/list_scoped_builder.dart';

class CreateIncomeScreen extends StatefulWidget {
  const CreateIncomeScreen({
    super.key,
    required AccountStore accountStore,
    required IncomeStore incomeStore,
    required IncomeTypeStore typeStore,
  })  : _accountStore = accountStore,
        _incomeStore = incomeStore,
        _typeStore = typeStore;

  final AccountStore _accountStore;
  final IncomeStore _incomeStore;
  final IncomeTypeStore _typeStore;

  @override
  State<CreateIncomeScreen> createState() => _CreateIncomeScreenState();
}

class _CreateIncomeScreenState extends State<CreateIncomeScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameFieldController;
  late final TextEditingController _valueFieldController;
  late final TextEditingController _personNameFieldController;

  late final FocusNode _nameFieldFocusNode;
  late final FocusNode _valueFieldFocusNode;
  late final FocusNode _personNameFocusNode;

  Account? account;
  Frequency frequency = Frequency.none;
  IncomeType? type;
  Date date = Date.today();
  String? logicalTypeError;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _nameFieldController = TextEditingController();
    _valueFieldController = TextEditingController(text: 'R\$0,00');
    _personNameFieldController = TextEditingController();

    _nameFieldFocusNode = FocusNode();
    _valueFieldFocusNode = FocusNode();
    _personNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _valueFieldController.dispose();
    _personNameFieldController.dispose();

    _nameFieldFocusNode.dispose();
    _valueFieldFocusNode.dispose();
    _personNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Nova Receita',
                onMonthChange: (_, __) {},
                initialMonthAndYear: Date.today(),
                showMonthChanger: false,
              ),
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
                          label: 'Conta a depositar',
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
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Preencha o campo Nome';
                      }

                      if (name.length < 5) {
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
                  ),
                  FrequencySelector(
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
                  ListScopedBuilder<IncomeTypeStore, List<IncomeType>>(
                    store: widget._typeStore,
                    loadingWidget: const CircularProgressIndicator.adaptive(),
                    onEmptyState: () {
                      UmbrellaDialogs.showError(
                        context,
                        Fail(
                            "Não foi possível obter as Categorias. Por favor, aperte em 'Tentar novamente'"),
                        onRetry: () => widget._typeStore.getAll(),
                      );
                      return const SizedBox.shrink();
                    },
                    onError: (ctx, fail) {
                      fail is NetworkFail
                          ? UmbrellaDialogs.showNetworkProblem(context,
                              onRetry: () => widget._typeStore.getAll())
                          : UmbrellaDialogs.showError(context, fail,
                              onRetry: () => widget._typeStore.getAll());

                      /*TODO Create a Widget that substitutes the category selector on fetch error and empty state */
                      return const SizedBox.shrink();
                    },
                    onState: (ctx, types) => RadialSelector<IncomeType>(
                      items: types,
                      itemBuilder: (type) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
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
                            Text(
                              type.name,
                              style: const TextStyle(
                                fontSize: UmbrellaSizes.medium,
                              ),
                            ),
                          ],
                        );
                      },
                      onItemTap: (newType) {
                        setState(() {
                          type = newType;
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
                                  type?.name ?? 'Indefinido',
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
                                        type == null
                                            ? 'assets/icons/undefined.png'
                                            : 'assets/${type!.icon}',
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
                  ),
                  DefaultTextField(
                    height: 70.0,
                    controller: _personNameFieldController,
                    focusNode: _personNameFocusNode,
                    labelText: 'Quem deve isso a você? (Opcional)',
                    maxLength: 20,
                    validator: (_) => null,
                    padding: const EdgeInsets.only(top: 30.0),
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
                  onPressed: () {
                    _onFormSubmitted(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmitted(BuildContext context) {
    var (isFormValid, message) = _validateForm();

    if (!isFormValid) {
      UmbrellaDialogs.showError(
          context,
          Fail(message ??
              'Parece que o formulário contém erros. Corrija-os e tente denovo'));
      return;
    }

    String totalValueStr =
        CurrencyInputFormatter.unformat(_valueFieldController.text);

    Income newIncome = Income(
        id: 0,
        name: _nameFieldController.text,
        totalValue: double.parse(totalValueStr),
        paidValue: 0.00,
        remainingValue: double.parse(totalValueStr),
        dueDate: date,
        type: type!,
        frequency: frequency,
        personName: _personNameFieldController.text.trim().isEmpty
            ? null
            : _personNameFieldController.text.trim());

    widget._incomeStore.register(newIncome, account!).then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Receita Cadastrada',
          message:
              'Sua receita foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Principal',
        );
        Navigator.pushReplacementNamed(context, '/finance_manager/');
      }, (failure) {
        UmbrellaDialogs.showError(context, failure);
      });
    });
  }

  void _resetForm() {
    setState(() {
      _nameFieldController.clear();
      _valueFieldController.clear();
      _personNameFieldController.clear();
      frequency = Frequency.none;
      date = Date.today();
      type = null;
      logicalTypeError = null;
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

    if (type == null) {
      setState(() {
        logicalTypeError = 'Um Tipo de Despesa deve ser selecionado';
      });
      return (false, null);
    }
    return (true, null);
  }
}
