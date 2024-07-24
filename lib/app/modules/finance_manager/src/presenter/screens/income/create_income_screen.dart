import 'package:flutter/material.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/entities/income.dart';
import '../../../errors/errors.dart';
import '../../controllers/balance_store.dart';
import '../../utils/currency_input_formatter.dart';
import '../../utils/umbrella_palette.dart';
import '../../controllers/account_store.dart';
import '../../controllers/income_store.dart';
import '../../controllers/income_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/simple_information/category_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/selectors/category_selector.dart';
import '../../widgets/selectors/date_selector.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/texts/small_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/selectors/frequency_selector.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/forms/number_text_field.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/texts/medium_text.dart';

class CreateIncomeScreen extends StatefulWidget {
  const CreateIncomeScreen({
    super.key,
    required AccountStore accountStore,
    required IncomeStore incomeStore,
    required IncomeCategoryStore categoryStore,
    required BalanceStore balanceStore,
  })  : _accountStore = accountStore,
        _balanceStore = balanceStore,
        _incomeStore = incomeStore,
        _categoryStore = categoryStore;

  final AccountStore _accountStore;
  final BalanceStore _balanceStore;
  final IncomeStore _incomeStore;
  final IncomeCategoryStore _categoryStore;

  @override
  State<CreateIncomeScreen> createState() => _CreateIncomeScreenState();
}

class _CreateIncomeScreenState extends State<CreateIncomeScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController nameFieldController;
  late final TextEditingController valueFieldController;
  late final TextEditingController personNameFieldController;

  late final FocusNode nameFieldFocusNode;
  late final FocusNode valueFieldFocusNode;
  late final FocusNode personNameFocusNode;

  Account? account;
  Frequency frequency = Frequency.none;
  Category? category;
  Date date = Date.today();
  String? logicalCategoryError;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    nameFieldController = TextEditingController();
    valueFieldController = TextEditingController(text: 'R\$0,00');
    personNameFieldController = TextEditingController();

    nameFieldFocusNode = FocusNode();
    valueFieldFocusNode = FocusNode();
    personNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    valueFieldController.dispose();
    personNameFieldController.dispose();

    nameFieldFocusNode.dispose();
    valueFieldFocusNode.dispose();
    personNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        accountStore: widget._accountStore,
        balanceStore: widget._balanceStore,
        title: 'Nova Receita',
      ),
      child: SingleChildScrollView(
        child: MyForm(
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

                return AccountSelector(
                  accounts: accounts,
                  selectedAccount: account!,
                  label: 'Conta a depositar',
                  onSelected: (acc) {
                    setState(() {
                      account = acc;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 15.0),
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
              controller: nameFieldController,
              focusNode: nameFieldFocusNode,
              maxLength: 30,
              labelText: 'Nome',
            ),
            NumberTextField(
              controller: valueFieldController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              isCurrency: true,
              label: 'Valor',
              initialValue: 0.00,
              focusNode: valueFieldFocusNode,
              validate: (number) {
                if (number == 0.00) {
                  return 'O Valor deve ser maior que 0';
                }

                return null;
              },
            ),
            FrequencySelector(
              title: 'Qual a Frequência dessa Receita?',
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
                date: date,
                onDateSelected: (newDate) {
                  setState(() {
                    date = newDate;
                  });
                },
              ),
            ),
            ListScopedBuilder<IncomeCategoryStore, List<Category>>(
              store: widget._categoryStore,
              loadingWidget: const CircularProgressIndicator.adaptive(),
              onEmptyState: () {
                UmbrellaDialogs.showError(
                  context,
                  "Não foi possível obter as Categorias. Por favor, aperte em 'Tentar novamente'",
                  onRetry: () => widget._categoryStore.getAll(),
                );
                return const SizedBox.shrink();
              },
              onError: (ctx, fail) {
                fail is NetworkFail
                    ? UmbrellaDialogs.showNetworkProblem(context,
                        onRetry: () => widget._categoryStore.getAll())
                    : UmbrellaDialogs.showError(context, fail.message,
                        onRetry: () => widget._categoryStore.getAll());

                /*TODO Create a Widget that substitutes the category selector on fetch error and empty state */
                return const SizedBox.shrink();
              },
              onState: (ctx, categories) => CategorySelector(
                categories: categories,
                onSelected: (newCategory) {
                  setState(() {
                    category = newCategory;
                    if (logicalCategoryError != null) {
                      logicalCategoryError = null;
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryRow(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      category: category,
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
            ),
            DefaultTextField(
              height: 70.0,
              controller: personNameFieldController,
              focusNode: personNameFocusNode,
              labelText: 'Quem deve isso a você? (Opcional)',
              maxLength: 20,
              validator: (_) => null,
              padding: const EdgeInsets.only(top: 30.0),
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
                onPressed: _onFormSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    var (isFormValid, message) = validateForm();

    if (!isFormValid) {
      UmbrellaDialogs.showError(
          context,
          message ??
              'Parece que o formulário contém erros. Corrija-os e tente denovo');
      return;
    }

    String totalValueStr =
        CurrencyInputFormatter.unformat(valueFieldController.text);

    Income newIncome = Income(
        id: 0,
        name: nameFieldController.text,
        totalValue: double.parse(totalValueStr),
        paidValue: 0.00,
        remainingValue: double.parse(totalValueStr),
        dueDate: date,
        category: category!,
        frequency: frequency,
        account: account!,
        personName: personNameFieldController.text.trim().isEmpty
            ? null
            : personNameFieldController.text.trim());

    widget._incomeStore.register(newIncome).then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Receita Cadastrada',
          message:
              'Sua receita foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Principal',
        );
        Navigator.pushReplacementNamed(context, '/finance_manager/');
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }

  void resetForm() {
    setState(() {
      nameFieldController.clear();
      valueFieldController.text = 'R\$ 0,00';
      personNameFieldController.clear();
      frequency = Frequency.none;
      date = Date.today();
      category = null;
      logicalCategoryError = null;
    });
  }

  (bool, String? message) validateForm() {
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
        logicalCategoryError = 'Uma categoria deve ser selecionado';
      });
      return (false, null);
    }
    return (true, null);
  }
}
