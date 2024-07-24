import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_category_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/frequency.dart';
import '../../controllers/account_store.dart';
import '../../controllers/expense_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/simple_information/account_name.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/simple_information/category_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/selectors/category_selector.dart';
import '../../widgets/selectors/date_selector.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/selectors/frequency_selector.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/simple_information/value_row.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({
    super.key,
    required ExpenseStore expenseStore,
    required ExpenseCategoryStore categoryStore,
    required AccountStore accountStore,
    required BalanceStore balanceStore,
    required Expense expense,
  })  : _expenseStore = expenseStore,
        _categoryStore = categoryStore,
        _accountStore = accountStore,
        _balanceStore = balanceStore,
        _expense = expense;

  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;
  final AccountStore _accountStore;
  final BalanceStore _balanceStore;
  final Expense _expense;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameFieldController;

  late final TextEditingController personNameFieldController;

  late final FocusNode nameFieldFocusNode;
  late final FocusNode personNameFocusNode;

  late Frequency frequency;
  late Date date;
  late Category category;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
    nameFieldController = TextEditingController();
    personNameFieldController = TextEditingController();

    nameFieldFocusNode = FocusNode();
    personNameFocusNode = FocusNode();

    setVariablesToOriginal();
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    personNameFieldController.dispose();

    nameFieldFocusNode.dispose();
    personNameFocusNode.dispose();
    super.dispose();
  }

  void setVariablesToOriginal() {
    nameFieldController.text = widget._expense.name;
    frequency = widget._expense.frequency;
    date = widget._expense.dueDate.copyWith();
    category = widget._expense.category;
    personNameFieldController.text = widget._expense.personName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Editar Despesa',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AccountName(
                trailingText: 'Debitando de',
                account: widget._expense.account,
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: ValueRow(
                trailingText: 'Valor da Despesa',
                alignment: MainAxisAlignment.spaceBetween,
                value: widget._expense.totalValue,
              ),
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
                date: date,
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
                onSelected: (cat) {
                  setState(() {
                    category = cat;
                  });
                },
                child: CategoryRow(
                  category: category,
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                ),
              ),
              onError: (context, e) => CategoryRow(
                category: category,
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
              ),
              onLoading: (context) =>
                  const CircularProgressIndicator.adaptive(),
            ),
            DefaultTextField(
              height: 70.0,
              controller: personNameFieldController,
              focusNode: personNameFocusNode,
              labelText: 'A Quem você deve isso? (Opcional)',
              maxLength: 20,
              validator: (_) => null,
              padding: const EdgeInsets.only(top: 30.0),
            ),
            Spaced(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
                vertical: 20.0,
              ),
              first: ResetButton(reset: resetForm),
              second: PrimaryButton(
                label: const MediumText.bold('Atualizar'),
                onPressed: onFormSubmitted,
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

  void onFormSubmitted() {
    bool isFormValid = validateForm();

    if (!isFormValid) {
      UmbrellaDialogs.showError(
        context,
        'Parece que o formulário contém erros. Corrija-os e tente denovo',
      );
      return;
    }

    update();
  }

  void resetForm() {
    setState(() {
      setVariablesToOriginal();
    });
  }

  bool validateForm() => formKey.currentState!.validate();

  Future<void> update() async {
    String personName = personNameFieldController.text.trim();

    Expense newExpense = widget._expense.copyWith(
      name: nameFieldController.text,
      dueDate: date,
      frequency: frequency,
      category: category,
      personName: personName.isEmpty ? null : personName,
    );

    widget._expenseStore
        .edit(newPaiyable: newExpense, oldPaiyable: widget._expense)
        .then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Despesa Atualizada',
          message: 'Sua despesa foi atualizada com sucesso.',
        ).then((_) {
          Navigator.pop(context);
        });
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }
}
