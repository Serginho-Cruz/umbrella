import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String? value) validator;
  final void Function(String?)? onChanged;
  final void Function(String)? onSubmitted;
  final String labelText;
  final double? height;
  final double? width;
  final bool readOnly;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;

  const DefaultTextField({
    super.key,
    this.focusNode,
    this.height,
    this.width,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.readOnly = false,
    required this.validator,
    required this.labelText,
    this.inputFormatters,
    this.onChanged,
    this.initialValue,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        readOnly: readOnly,
        validator: validator,
        controller: controller,
        initialValue: initialValue,
        focusNode: focusNode,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
