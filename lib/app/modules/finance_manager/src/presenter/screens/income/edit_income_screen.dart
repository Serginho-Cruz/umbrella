import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/entities/income.dart';
import '../../controllers/income_store.dart';
import '../../controllers/income_category_store.dart';
import '../../widgets/simple_information/account_name.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/tiles/category_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/selectors/category_selector.dart';
import '../../widgets/selectors/date_selector.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/selectors/frequency_selector.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/simple_information/value_row.dart';

class EditIncomeScreen extends StatefulWidget {
  const EditIncomeScreen({
    super.key,
    required IncomeStore incomeStore,
    required IncomeCategoryStore categoryStore,
    required Income income,
  })  : _incomeStore = incomeStore,
        _categoryStore = categoryStore,
        _income = income;

  final IncomeStore _incomeStore;
  final IncomeCategoryStore _categoryStore;
  final Income _income;

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameFieldController;
  late final TextEditingController personNameFieldController;

  late final FocusNode nameFieldFocusNode;
  late final FocusNode personNameFocusNode;

  late Frequency frequency;
  late Category category;
  late Date date;

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
    nameFieldController.text = widget._income.name;
    frequency = widget._income.frequency;
    date = widget._income.dueDate.copyWith();
    category = widget._income.category;
    personNameFieldController.text = widget._income.personName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBarTitle: 'Editar Receita',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyForm(
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
                  trailingText: 'Acrescentando a',
                  account: widget._income.account,
                ),
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
                controller: nameFieldController,
                focusNode: nameFieldFocusNode,
                maxLength: 30,
                labelText: 'Nome',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                child: ValueRow(
                  trailingText: 'Valor da Receita',
                  alignment: MainAxisAlignment.spaceBetween,
                  value: widget._income.totalValue,
                ),
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
                onEmptyState: () => CategoryRow(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  category: category,
                ),
                onError: (ctx, fail) => CategoryRow(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  category: category,
                ),
                onState: (ctx, categories) => CategorySelector(
                  categories: categories,
                  onSelected: (newCategory) {
                    setState(() {
                      category = newCategory;
                    });
                  },
                  child: CategoryRow(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    category: category,
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
            ],
          ),
          Spaced(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05,
              vertical: 20.0,
            ),
            first: ResetButton(reset: resetForm),
            second: PrimaryButton(
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.black,
                size: 24.0,
              ),
              label: const MediumText.bold('Atualizar'),
              onPressed: onFormSubmitted,
            ),
          ),
        ],
      ),
    );
  }

  void onFormSubmitted() {
    var (isFormValid) = validateForm();

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

  void update() {
    String personName = personNameFieldController.text.trim();

    Income newIncome = widget._income.copyWith(
      name: nameFieldController.text,
      dueDate: date,
      frequency: frequency,
      category: category,
      personName: personName.isEmpty ? null : personName,
    );

    widget._incomeStore
        .updateIncome(newIncome: newIncome, oldIncome: widget._income)
        .then((result) {
      result.fold((success) {
        UmbrellaDialogs.showSuccess(
          context,
          title: 'Receita Atualizada',
          message:
              'Sua receita foi atualizada com sucesso. Iremos redireciona-lo de volta',
        ).then((_) {
          Navigator.pop(context);
        });
      }, (failure) {
        UmbrellaDialogs.showError(context, failure.message);
      });
    });
  }
}
