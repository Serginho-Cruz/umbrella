import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/currency_input_formatter.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    super.key,
    this.padding = EdgeInsets.zero,
    this.controller,
    required this.label,
    this.isCurrency = false,
    this.width,
    this.height,
    this.isOptional = false,
    required this.validate,
    this.focusNode,
    this.initialValue,
    this.maxLength,
    this.onChange,
  });

  final FocusNode? focusNode;
  final bool isCurrency;
  final bool isOptional;
  final TextEditingController? controller;
  final String? Function(double) validate;
  final double? initialValue;
  final String label;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final int? maxLength;
  final void Function(double?)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          controller: controller,
          maxLength: maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          onChanged: onChange == null ? null : onChanged,
          inputFormatters: [
            isCurrency
                ? CurrencyInputFormatter()
                : FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: label,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: validator,
          focusNode: focusNode,
        ),
      ),
    );
  }

  void onChanged(String? text) {
    String? numberText =
        isCurrency ? CurrencyInputFormatter.unformat(text!) : text;

    double? value;

    if (numberText != null) {
      value = double.tryParse(numberText);
    }

    onChange?.call(value);
  }

  String? validator(String? actualText) {
    if (isOptional && actualText == null) {
      return null;
    }

    if (actualText == null) {
      return 'O Campo é Obrigatório';
    }

    if (isCurrency) {
      actualText = CurrencyInputFormatter.unformat(actualText);
    }

    if (double.tryParse(actualText) == null) {
      return 'Valor Inválido. O Campo deve conter um número';
    }

    double number = double.parse(actualText);
    var error = validate(number);

    if (error != null) return error;

    return null;
  }
}
