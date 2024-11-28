import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/expense_category_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/spaced.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../errors/errors.dart';
import '../../stores/expense_store.dart';
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
  })  : _expenseStore = expenseStore,
        _categoryStore = categoryStore;

  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _nameController;
  late final TextEditingController _personNameController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();

    _nameController = TextEditingController();
    _personNameController = TextEditingController();

    _setListeners();

    _setVariablesToOriginal();
  }

  void _setVariablesToOriginal() {
    var model = widget._expenseStore.selectedModel!;

    widget._expenseStore.setAccount(model.account);
    widget._expenseStore.setValue(model.totalValue);
    widget._expenseStore.setCategory(model.category);
    widget._expenseStore.setDueDate(model.overdueDate);
    widget._expenseStore.setFrequency(model.frequency);

    _nameController.text = model.name;
    _personNameController.text = model.personName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Editar Despesa',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AccountName(
                trailingText: 'Debitando de',
                account: widget._expenseStore.selectedModel!.account,
              ),
            ),
            Observer(
              builder: (_) => DefaultTextField(
                validator: widget._expenseStore.validateName,
                onChanged: widget._expenseStore.setName,
                initialValue: widget._expenseStore.name,
                readOnly: widget._expenseStore.isLoading,
                maxLength: 30,
                labelText: 'Nome',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: ValueRow(
                trailingText: 'Valor da Despesa',
                alignment: MainAxisAlignment.spaceBetween,
                value: widget._expenseStore.selectedModel!.totalValue,
              ),
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
                  child: Observer(
                    builder: (_) => CategoryRow(
                      category: widget._expenseStore.category,
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    ),
                  ),
                ),
                onEmpty: (_) => CategoryRow(
                  category: widget._expenseStore.selectedModel?.category,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                onFail: (context, e) => CategoryRow(
                  category: widget._expenseStore.selectedModel?.category,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                onLoading: (context) =>
                    const CircularProgressIndicator.adaptive(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Observer(
                builder: (_) => DefaultTextField(
                  initialValue: widget._expenseStore.personName,
                  height: 70.0,
                  labelText: 'A Quem você deve isso? (Opcional)',
                  maxLength: 20,
                  onChanged: widget._expenseStore.setPersonName,
                  validator: widget._expenseStore.validatePersonName,
                  readOnly: widget._expenseStore.isLoading,
                ),
              ),
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
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
    _personNameController.dispose();
    super.dispose();
  }

  void _setListeners() {
    _nameController.addListener(() {
      widget._expenseStore.setName(_nameController.text);
    });

    _personNameController.addListener(() {
      widget._expenseStore.setPersonName(_personNameController.text);
    });
  }

  void onFormSubmitted() {
    if (!_formKey.currentState!.validate()) {
      UmbrellaDialogs.showError(
        context,
        'Parece que o formulário contém erros. Corrija-os e tente denovo',
      );
      return;
    }

    widget._expenseStore.edit().then((fail) {
      switch (fail) {
        case Fail f when mounted:
          UmbrellaDialogs.showError(context, f.message);
          break;
        case null when mounted:
          UmbrellaDialogs.showSuccess(
            context,
            title: 'Despesa Atualizada',
            message:
                'Sua despesa foi atualizada com sucesso. Iremos redireciona-lo de volta',
          ).then((_) {
            if (mounted) Navigator.pop(context);
          });
      }
    });
  }

  void resetForm() {
    _setVariablesToOriginal();
  }
}
