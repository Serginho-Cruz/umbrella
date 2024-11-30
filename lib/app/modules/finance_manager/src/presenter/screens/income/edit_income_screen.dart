import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../errors/errors.dart';
import '../../stores/income_store.dart';
import '../../stores/income_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/simple_information/account_name.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/simple_information/category_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/selectors/category_selector.dart';
import '../../widgets/selectors/date_selector.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/selectors/frequency_selector.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/simple_information/value_row.dart';

class EditIncomeScreen extends StatefulWidget {
  const EditIncomeScreen({
    super.key,
    required IncomeStore incomeStore,
    required IncomeCategoryStore categoryStore,
  })  : _incomeStore = incomeStore,
        _categoryStore = categoryStore;

  final IncomeStore _incomeStore;
  final IncomeCategoryStore _categoryStore;

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
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

    setVariablesToOriginal();
  }

  void setVariablesToOriginal() {
    var model = widget._incomeStore.selectedModel!;

    widget._incomeStore.setAccount(model.account);
    widget._incomeStore.setValue(model.totalValue);
    widget._incomeStore.setCategory(model.category);
    widget._incomeStore.setDueDate(model.overdueDate);
    widget._incomeStore.setFrequency(model.frequency);

    _nameController.text = model.name;
    _personNameController.text = model.personName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Editar Receita',
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
                trailingText: 'Acrescentando a',
                account: widget._incomeStore.selectedModel!.account,
              ),
            ),
            Observer(
              builder: (_) => DefaultTextField(
                controller: _nameController,
                validator: widget._incomeStore.validateName,
                maxLength: 30,
                labelText: 'Nome',
                readOnly: widget._incomeStore.isLoading,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: ValueRow(
                trailingText: 'Valor da Receita',
                alignment: MainAxisAlignment.spaceBetween,
                value: widget._incomeStore.selectedModel!.totalValue,
              ),
            ),
            Observer(
              builder: (_) => FrequencySelector(
                title: 'Qual a Frequência dessa Receita?',
                selectedFrequency: widget._incomeStore.frequency,
                onSelected: widget._incomeStore.setFrequency,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Observer(
                builder: (_) => DateSelector(
                  date: widget._incomeStore.dueDate,
                  onDateSelected: widget._incomeStore.setDueDate,
                ),
              ),
            ),
            Observer(
              builder: (_) => ListSegmentedStateWidget(
                state: widget._categoryStore.state,
                onLoading: (ctx) => const CircularProgressIndicator.adaptive(),
                onEmpty: (ctx) => CategoryRow(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  category: widget._incomeStore.selectedModel?.category,
                ),
                onFail: (ctx, fail) => CategoryRow(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  category: widget._incomeStore.selectedModel?.category,
                ),
                onState: (ctx, categories) => CategorySelector(
                  categories: categories,
                  onSelected: widget._incomeStore.setCategory,
                  child: Observer(
                    builder: (_) => CategoryRow(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      category: widget._incomeStore.category,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Observer(
                builder: (_) => DefaultTextField(
                  controller: _personNameController,
                  height: 70.0,
                  labelText: 'Quem deve isso a você? (Opcional)',
                  maxLength: 20,
                  validator: widget._incomeStore.validatePersonName,
                  readOnly: widget._incomeStore.isLoading,
                ),
              ),
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              first: SecondaryButton(onPressed: resetForm),
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
      ),
    );
  }

  @override
  void dispose() {
    widget._incomeStore.setAccount(null);
    widget._incomeStore.setValue(0.00);
    widget._incomeStore.setCategory(null);
    widget._incomeStore.setDueDate(Date.today());
    widget._incomeStore.setFrequency(Frequency.none);

    widget._incomeStore.setName(null);
    widget._incomeStore.setPersonName(null);

    _nameController.dispose();
    _personNameController.dispose();
    super.dispose();
  }

  void _setListeners() {
    _nameController.addListener(() {
      widget._incomeStore.setName(_nameController.text);
    });

    _personNameController.addListener(() {
      widget._incomeStore.setPersonName(_personNameController.text);
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

    widget._incomeStore.edit().then((fail) {
      switch (fail) {
        case Fail f when mounted:
          UmbrellaDialogs.showError(context, f.message);
          break;
        case null when mounted:
          UmbrellaDialogs.showSuccess(
            context,
            title: 'Receita Atualizada',
            message:
                'Sua receita foi atualizada com sucesso. Iremos redireciona-lo de volta',
          ).then((_) {
            if (mounted) Navigator.pop(context);
          });
      }
    });
  }

  void resetForm() {
    setVariablesToOriginal();
  }
}
