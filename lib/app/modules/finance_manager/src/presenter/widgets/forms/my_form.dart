import 'package:flutter/material.dart';

class MyForm extends StatelessWidget {
  const MyForm({
    super.key,
    this.formKey,
    this.padding,
    this.width,
    required this.children,
  });

  final Key? formKey;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: Form(
          key: formKey,
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
