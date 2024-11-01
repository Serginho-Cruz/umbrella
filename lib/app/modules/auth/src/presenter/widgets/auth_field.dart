import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.focusNode,
    this.padding = EdgeInsets.zero,
    this.autovalidateMode = AutovalidateMode.onUnfocus,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    required this.validate,
  });

  final AutovalidateMode autovalidateMode;
  final EdgeInsetsGeometry padding;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        keyboardType: keyboardType,
        focusNode: focusNode,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.black, size: 20.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorMaxLines: 2,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
        readOnly: readOnly,
        onTapOutside: onTapOutside,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        validator: validate,
      ),
    );
  }
}
