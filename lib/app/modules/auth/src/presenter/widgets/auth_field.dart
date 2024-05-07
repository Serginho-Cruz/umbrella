import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    required this.validate,
    required this.focusNode,
    this.padding = EdgeInsets.zero,
    this.nextFocusNode,
    this.errorText,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String? Function(String?) validate;
  final String? errorText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? errorText;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        obscureText: widget.isPassword ? showPassword : false,
        decoration: InputDecoration(
          labelText: widget.label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(widget.icon, color: Colors.black, size: 20.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorText: errorText,
          errorMaxLines: 2,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: widget.isPassword
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.black,
                    size: 20.0,
                  ),
                )
              : null,
        ),
        onTapOutside: (_) {
          widget.focusNode.unfocus();
          _validateField();
        },
        onEditingComplete: () {
          widget.focusNode.unfocus();
          _validateField();
          if (errorText == null) widget.nextFocusNode?.requestFocus();
        },
        onChanged: (_) {
          if (errorText != null) {
            setState(() {
              errorText = null;
            });
          }
        },
        validator: widget.validate,
      ),
    );
  }

  void _validateField() {
    String text = widget.controller.text;

    var result = widget.validate(text);

    if (result != null) {
      setState(() {
        errorText = result;
      });
    }
  }
}
