import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String? value)? validator;
  final void Function()? onEditingComplete;
  final String? labelText;
  final double? height;
  final EdgeInsetsGeometry padding;

  const DefaultTextField({
    super.key,
    this.focusNode,
    this.height,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.onEditingComplete,
    this.labelText,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height ?? 75.0,
        child: TextFormField(
          validator: validator,
          controller: controller,
          focusNode: focusNode,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onEditingComplete: () {
            onEditingComplete?.call();
            focusNode?.unfocus();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (_) => focusNode?.unfocus(),
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}
