import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_category_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/selectors/account_selector.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../errors/api_errors.dart';
import '../../utils/umbrella_palette.dart';
import '../../controllers/account_store.dart';
import '../../controllers/expense_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/simple_information/category_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/selectors/category_selector.dart';
import '../../widgets/selectors/date_selector.dart';
import '../../widgets/texts/small_text.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/selectors/frequency_selector.dart';
import '../../widgets/forms/number_text_field.dart';
import '../../widgets/texts/medium_text.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({
    super.key,
    required ExpenseStore expenseStore,
    required ExpenseCategoryStore categoryStore,
    required AccountStore accountStore,
  })  : _expenseStore = expenseStore,
        _categoryStore = categoryStore,
        _accountStore = accountStore;

  final AccountStore _accountStore;
  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _nameController;
  late final TextEditingController _valueController;
  late final TextEditingController _personNameController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _nameController = TextEditingController();
    _valueController = TextEditingController();

    _personNameController = TextEditingController();

    _setListeners();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Nova Despesa',
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
            Observer(
              builder: (_) => ListSegmentedStateWidget(
                state: widget._accountStore.state,
                onLoading: (_) => const CircularProgressIndicator.adaptive(),
                onFail: (ctx, fail) => Text(fail.message),
                onEmpty: (_) => Container(),
                onState: (ctx, accounts) {
                  widget._expenseStore
                      .setAccount(accounts.firstWhere((acc) => acc.isDefault));

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Observer(
                      builder: (_) => AccountSelector(
                        accounts: accounts,
                        selectedAccount: widget._expenseStore.account,
                        label: 'Conta a debitar',
                        onSelected: widget._expenseStore.setAccount,
                      ),
                    ),
                  );
                },
              ),
            ),
            Observer(
              builder: (_) => DefaultTextField(
                validator: widget._expenseStore.validateName,
                controller: _nameController,
                readOnly: widget._expenseStore.isLoading,
                maxLength: 30,
                labelText: 'Nome',
              ),
            ),
            Observer(
              builder: (_) {
                return NumberTextField(
                  controller: _valueController,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  isCurrency: true,
                  label: 'Valor',
                  validate: widget._expenseStore.validateValue,
                  onChange: widget._expenseStore.setValue,
                  readOnly: widget._expenseStore.isLoading,
                );
              },
            ),
            Observer(
              builder: (_) => FrequencySelector(
                title: 'Qual a Frequência dessa Despesa?',
                selectedFrequency: widget._expenseStore.frequency,
                onSelected: widget._expenseStore.setFrequency,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Observer(
                builder: (_) => DateSelector(
                  date: widget._expenseStore.dueDate,
                  onDateSelected: widget._expenseStore.setDueDate,
                ),
              ),
            ),
            Observer(
              builder: (_) => ListSegmentedStateWidget<Category>(
                state: widget._categoryStore.state,
                onState: (ctx, categories) => CategorySelector(
                  categories: categories,
                  onSelected: widget._expenseStore.setCategory,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryRow(
                        category: widget._expenseStore.category,
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      ),
                      Visibility(
                        visible: widget._expenseStore.category != null,
                        child: const SmallText(
                          'Uma categoria precisa ser selecionada',
                          color: UmbrellaPalette.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
                onEmpty: (ctx) {
                  UmbrellaDialogs.showError(
                    ctx,
                    "Não foi possível obter as Categorias. Por favor, aperte em 'Tentar novamente'",
                    onRetry: () => widget._categoryStore.getAll(),
                  );
                  return const SizedBox.shrink();
                },
                onFail: (context, fail) {
                  fail is NetworkFail
                      ? UmbrellaDialogs.showNetworkProblem(context,
                          onRetry: () => widget._categoryStore.getAll())
                      : UmbrellaDialogs.showError(context, fail.message,
                          onRetry: () => widget._categoryStore.getAll());

                  return const SizedBox.shrink();
                },
                onLoading: (context) =>
                    const CircularProgressIndicator.adaptive(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: DefaultTextField(
                controller: _personNameController,
                height: 70.0,
                labelText: 'Quem deve isso a você? (Opcional)',
                maxLength: 20,
                validator: widget._expenseStore.validatePersonName,
                readOnly: widget._expenseStore.isLoading,
              ),
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
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
      ),
    );
  }

  @override
  void dispose() {
    widget._expenseStore.setAccount(null);
    widget._expenseStore.setValue(0.00);
    widget._expenseStore.setCategory(null);
    widget._expenseStore.setDueDate(Date.today());
    widget._expenseStore.setFrequency(Frequency.none);

    widget._expenseStore.setName(null);
    widget._expenseStore.setPersonName(null);

    _nameController.dispose();
    _valueController.dispose();
    _personNameController.dispose();

    super.dispose();
  }

  void _onFormSubmitted() {
    if (!_formKey.currentState!.validate()) {
      UmbrellaDialogs.showError(context,
          'Parece que o formulário contém erros. Corrija-os e tente denovo');
      return;
    }

    widget._expenseStore.register().then((fail) async {
      switch (fail) {
        case Fail f when mounted:
          UmbrellaDialogs.showError(context, f.message);
          break;
        case null when mounted:
          await UmbrellaDialogs.showSuccess(
            context,
            title: 'Despesa Cadastrada',
            message:
                'Sua despesa foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Anterior',
          );
          if (mounted) Navigator.pop(context);
          break;
      }
    });
  }

  void _setListeners() {
    _nameController.addListener(() {
      widget._expenseStore.setName(_nameController.text);
    });

    _personNameController.addListener(() {
      widget._expenseStore.setPersonName(_personNameController.text);
    });
  }

  void _resetForm() {
    _nameController.clear();
    _valueController.text = 'R\$ 0,00';
    widget._expenseStore.setFrequency(Frequency.none);
    widget._expenseStore.setDueDate(Date.today());
    widget._expenseStore.setCategory(null);
    _personNameController.clear();
  }
}
