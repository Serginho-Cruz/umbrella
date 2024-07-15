import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/paiyable.dart';
import '../../utils/currency_input_formatter.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../forms/my_form.dart';
import '../forms/number_text_field.dart';
import '../layout/dialog_layout.dart';
import '../layout/spaced.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import '../texts/title_text.dart';
import 'umbrella_dialogs.dart';

class ChangeValueDialog<P extends Paiyable> extends StatefulWidget {
  const ChangeValueDialog({
    super.key,
    required this.onValueAltered,
    required this.paiyable,
  });

  final P paiyable;
  final Future<String?> Function(double) onValueAltered;

  @override
  State<ChangeValueDialog> createState() => _ChangeValueDialogState();
}

class _ChangeValueDialogState extends State<ChangeValueDialog> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: 'R\$ 0,00');
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: MyForm(
        formKey: formKey,
        verticalSize: MainAxisSize.min,
        padding: const EdgeInsets.all(15.0),
        children: [
          const Align(child: TitleText.bold('Alterar Valor')),
          const SizedBox(height: 40.0),
          Row(
            children: [
              MediumText(_resolvePaiyableDisplayName()),
              const SizedBox(width: 10.0),
              MediumText.bold(_resolvePaiyableName()),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              const MediumText('Valor Total:'),
              const SizedBox(width: 10.0),
              Price.medium(
                widget.paiyable.totalValue,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          NumberTextField(
            controller: controller,
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            isCurrency: true,
            label: 'Novo Valor',
            initialValue: 0.00,
            focusNode: focusNode,
            validate: (number) {
              if (number == 0.00) {
                return 'O Valor deve ser maior que 0';
              }

              return null;
            },
          ),
          Spaced(
            first: SecondaryButton(
              width: MediaQuery.sizeOf(context).width * 0.25,
              label: const MediumText.bold('Voltar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            second: PrimaryButton(
              width: MediaQuery.sizeOf(context).width * 0.4,
              icon: const Icon(
                Icons.edit_square,
                color: Colors.black,
                size: 24.0,
              ),
              label: const MediumText.bold('Alterar'),
              onPressed: alterValue,
            ),
          ),
        ],
      ),
    );
  }

  void alterValue() {
    String unformatted = CurrencyInputFormatter.unformat(controller.text);

    double newValue = double.parse(unformatted);
    widget.onValueAltered(newValue).then((error) {
      error != null
          ? UmbrellaDialogs.showError(
              context,
              error,
              onRetry: alterValue,
              onConfirmPressed: () => Navigator.pop(context),
            )
          : Navigator.pop(context);
    });
  }

  String _resolvePaiyableDisplayName() {
    return switch (widget.paiyable) {
      Expense() => 'Despesa:',
      Income() => 'Receita:',
      Invoice() => 'Fatura:',
      Paiyable() => '',
    };
  }

  String _resolvePaiyableName() {
    if (widget.paiyable is Income) {
      var inc = widget.paiyable as Income;
      return inc.name;
    }

    if (widget.paiyable is Expense) {
      var exp = widget.paiyable as Expense;
      return exp.name;
    }

    var inv = widget.paiyable as Invoice;
    return '${inv.card.name} / ${inv.closingDate.monthName} de ${inv.closingDate.year}';
  }
}
