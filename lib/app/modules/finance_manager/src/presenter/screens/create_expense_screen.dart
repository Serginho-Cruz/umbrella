import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart' as intl;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/credit_card_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/app_bar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/button_with_icon.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/selectors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/credit_card_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/forms/my_form.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/spaced_widgets.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../widgets/forms/text_field.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameFieldController;
  late final TextEditingController _valueFieldController;
  late final TextEditingController _personNameFieldController;
  late final ExpansionTileController _tileController;
  late final FocusNode _nameFieldFocusNode;
  late final FocusNode _valueFieldFocusNode;
  late final FocusNode _personNameFocusNode;

  Frequency _frequency = Frequency.none;
  bool _willBePaidWithCredit = false;
  CreditCardModel? _cardSelected;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _nameFieldController = TextEditingController();
    _valueFieldController = TextEditingController();
    _personNameFieldController = TextEditingController();
    _tileController = ExpansionTileController();

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: const Text(
                  'Nova Despesa',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
                ),
                onMonthChange: (_, __) {},
                initialMonthAndYear: Date.today(),
                showBalances: true,
                showMonthChanger: false,
              ),
              MyForm(
                formKey: _formKey,
                padding: const EdgeInsets.only(top: 12.0),
                width: MediaQuery.of(context).size.width * 0.9,
                children: [
                  DefaultTextField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Preencha o Campo Nome'
                        : null,
                    controller: _nameFieldController,
                    focusNode: _nameFieldFocusNode,
                    maxLength: 30,
                    labelText: 'Nome',
                  ),
                  DefaultTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Coloque um Valor para a sua despesa";
                      }

                      value = value.replaceAll(RegExp(r'\.'), '');
                      value = value.replaceAll(RegExp(r','), '.');

                      if (double.parse(value) <= 0.00) {
                        return "O valor da despesa deve ser maior que 0";
                      }

                      return null;
                    },
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    controller: _valueFieldController,
                    focusNode: _valueFieldFocusNode,
                    maxLength: 15,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    labelText: 'Valor',
                    onEditingComplete: () {
                      var text = _valueFieldController.text
                          .replaceAll(RegExp(r','), '.');

                      _valueFieldController.text =
                          intl.NumberFormat.decimalPatternDigits(
                        decimalDigits: 2,
                        locale: 'pt_br',
                      ).format(double.parse(text));
                    },
                  ),
                  LinearSelector<Frequency>(
                    items: Frequency.values,
                    onItemTap: (frequency) {
                      setState(() {
                        _frequency = frequency;
                      });
                    },
                    title: const Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
                      child: Text(
                        "Qual a Frequência da sua Despesa?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    itemBuilder: (frequency) => Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
                      child: Row(
                        children: [
                          Text(
                            frequency.name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: SpacedWidgets(
                      first: const Text(
                        "Frequência",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      second: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _frequency.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 32.0,
                          )
                        ],
                      ),
                    ),
                  ),
                  SpacedWidgets(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
                    first: const Text(
                      "Tipo",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    second: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Juros Bancários',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2),
                            image: const DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                'assets/icons/pagamento.png',
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 32.0,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ExpansionTile(
                      onExpansionChanged: (value) {
                        if (value == false) {
                          _willBePaidWithCredit = false;
                          _tileController.collapse();
                        }
                      },
                      expansionAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                      ),
                      shape: const Border(),
                      tilePadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      collapsedShape: null,
                      title: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Configurações Adicionais',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      children: [
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          expansionAnimationStyle: AnimationStyle(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 500),
                          ),
                          controller: _tileController,
                          childrenPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          shape: const Border(),
                          onExpansionChanged: (willBePaidWithCredit) {
                            setState(() {
                              _willBePaidWithCredit = willBePaidWithCredit;

                              _cardSelected = null;
                            });
                          },
                          title: const Text(
                            'Despesa no Crédito',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          trailing: Switch(
                            value: _willBePaidWithCredit,
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: Colors.lightBlue,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            onChanged: (isActive) async {
                              setState(() {
                                _willBePaidWithCredit = isActive;
                              });

                              isActive
                                  ? _tileController.expand()
                                  : _tileController.collapse();
                              if (_willBePaidWithCredit) {
                                await Modular.get<CreditCardStore>().getAll();
                              }
                            },
                          ),
                          children: [
                            const Text('Cartão que será usado'),
                            _cardSelected != null
                                ? CreditCardWidget(creditCard: _cardSelected!)
                                : Container(
                                    height: 150,
                                    width: 275,
                                    margin: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Clique Aqui',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        DefaultTextField(
                          height: 70.0,
                          controller: _personNameFieldController,
                          focusNode: _personNameFocusNode,
                          labelText: 'Quem você deve? (Opcional)',
                          maxLength: 20,
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWithIcon(
                        onPressed: () {
                          _nameFieldController.clear();
                          _valueFieldController.clear();
                          _frequency = Frequency.none;
                          _cardSelected = null;
                          _personNameFieldController.clear();
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 24.0),
                        color: Colors.yellow,
                        text: 'Limpar',
                      ),
                      ButtonWithIcon(
                        onPressed: () {
                          _formKey.currentState!.validate();
                        },
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        color: const Color(0xFFCD8CFF),
                        text: 'Adicionar',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
