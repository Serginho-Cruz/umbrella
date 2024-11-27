import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../errors/api_errors.dart';
import '../../../errors/errors.dart';
import '../../utils/umbrella_palette.dart';
import '../../controllers/account_store.dart';
import '../../controllers/income_store.dart';
import '../../controllers/income_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/reset_button.dart';
import '../../widgets/others/list_segmented_state_widget.dart';
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
import '../../widgets/texts/medium_text.dart';

class CreateIncomeScreen extends StatefulWidget {
  const CreateIncomeScreen({
    super.key,
    required AccountStore accountStore,
    required IncomeStore incomeStore,
    required IncomeCategoryStore categoryStore,
  })  : _accountStore = accountStore,
        _incomeStore = incomeStore,
        _categoryStore = categoryStore;

  final AccountStore _accountStore;
  final IncomeStore _incomeStore;
  final IncomeCategoryStore _categoryStore;

  @override
  State<CreateIncomeScreen> createState() => _CreateIncomeScreenState();
}

class _CreateIncomeScreenState extends State<CreateIncomeScreen> {
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
  void dispose() {
    widget._incomeStore.setAccount(null);
    widget._incomeStore.setValue(0.00);
    widget._incomeStore.setCategory(null);
    widget._incomeStore.setDueDate(Date.today());
    widget._incomeStore.setFrequency(Frequency.none);

    widget._incomeStore.setName(null);
    widget._incomeStore.setPersonName(null);

    _nameController.dispose();
    _valueController.dispose();
    _personNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
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
            Observer(
              builder: (_) => ListSegmentedStateWidget(
                state: widget._accountStore.state,
                onLoading: (_) => const CircularProgressIndicator.adaptive(),
                onFail: (ctx, fail) => Text(fail.message),
                onEmpty: (_) => Container(),
                onState: (ctx, accounts) {
                  widget._incomeStore
                      .setAccount(accounts.firstWhere((acc) => acc.isDefault));

                  return Observer(
                    builder: (_) => AccountSelector(
                      accounts: accounts,
                      selectedAccount: widget._incomeStore.account,
                      label: 'Conta a depositar',
                      onSelected: widget._incomeStore.setAccount,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15.0),
            Observer(
              builder: (_) {
                return DefaultTextField(
                  controller: _nameController,
                  validator: widget._incomeStore.validateName,
                  maxLength: 30,
                  labelText: 'Nome',
                  readOnly: widget._incomeStore.isLoading,
                );
              },
            ),
            Observer(
              builder: (_) => NumberTextField(
                controller: _valueController,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                isCurrency: true,
                label: 'Valor',
                onChange: widget._incomeStore.setValue,
                validate: widget._incomeStore.validateValue,
                readOnly: widget._incomeStore.isLoading,
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
                onFail: (ctx, fail) {
                  fail is NetworkFail
                      ? UmbrellaDialogs.showNetworkProblem(context,
                          onRetry: () => widget._categoryStore.getAll())
                      : UmbrellaDialogs.showError(context, fail.message,
                          onRetry: () => widget._categoryStore.getAll());

                  return const SizedBox.shrink();
                },
                onEmpty: (ctx) {
                  UmbrellaDialogs.showError(
                    context,
                    "Não foi possível obter as Categorias. Por favor, aperte em 'Tentar novamente'",
                    onRetry: () => widget._categoryStore.getAll(),
                  );
                  return const SizedBox.shrink();
                },
                onState: (ctx, st) => CategorySelector(
                  categories: st,
                  onSelected: widget._incomeStore.setCategory,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Observer(
                        builder: (_) => CategoryRow(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          category: widget._incomeStore.category,
                        ),
                      ),
                      Observer(
                        builder: (_) => Visibility(
                          visible: widget._incomeStore.category == null,
                          child: const SmallText(
                            'Uma categoria precisa ser selecionada',
                            color: UmbrellaPalette.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: DefaultTextField(
                controller: _personNameController,
                height: 70.0,
                labelText: 'Quem deve isso a você? (Opcional)',
                maxLength: 20,
                validator: widget._incomeStore.validatePersonName,
                readOnly: widget._incomeStore.isLoading,
              ),
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
    if (!_formKey.currentState!.validate()) {
      UmbrellaDialogs.showError(context,
          'Parece que o formulário contém erros. Corrija-os e tente denovo');
      return;
    }

    widget._incomeStore.register().then((fail) async {
      switch (fail) {
        case Fail f when mounted:
          UmbrellaDialogs.showError(context, f.message);
          break;
        case null when mounted:
          await UmbrellaDialogs.showSuccess(
            context,
            title: 'Receita Cadastrada',
            message:
                'Sua receita foi cadastrada com sucesso. Iremos redireciona-lo para a Tela Anterior',
          );
          if (mounted) Navigator.pop(context);
          break;
      }
    });
  }

  void _setListeners() {
    _nameController.addListener(() {
      widget._incomeStore.setName(_nameController.text);
    });

    _personNameController.addListener(() {
      widget._incomeStore.setPersonName(_personNameController.text);
    });
  }

  void resetForm() {
    _nameController.clear();
    _valueController.text = 'R\$ 0,00';
    widget._incomeStore.setValue(0.00);
    widget._incomeStore.setFrequency(Frequency.none);
    widget._incomeStore.setDueDate(Date.today());
    widget._incomeStore.setCategory(null);
    _personNameController.clear();
  }
}
