import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String? value) validator;
  final void Function()? onEditingComplete;
  final String labelText;
  final double? height;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry padding;

  const DefaultTextField({
    super.key,
    this.focusNode,
    this.height,
    this.width,
    this.controller,
    this.keyboardType,
    this.maxLength,
    required this.validator,
    this.onEditingComplete,
    required this.labelText,
    this.inputFormatters,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          validator: validator,
          controller: controller,
          focusNode: focusNode,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onEditingComplete: () {
            focusNode?.unfocus();
            onEditingComplete?.call();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (_) => focusNode?.unfocus(),
          decoration: InputDecoration(
            labelText: labelText,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}
