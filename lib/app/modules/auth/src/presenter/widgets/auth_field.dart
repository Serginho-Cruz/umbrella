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
    this.nextFocusNode,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final ({bool isValid, String errorMessage}) Function(String) validate;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? errorText;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword ? showPassword : false,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, color: Colors.black, size: 20.0),
        border: const OutlineInputBorder(borderSide: BorderSide()),
        errorText: errorText,
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
        var isValid = _validateField();
        widget.focusNode.unfocus();
        if (isValid) widget.nextFocusNode?.requestFocus();
      },
      onChanged: (_) {
        if (errorText != null) {
          setState(() {
            errorText = null;
          });
        }
      },
    );
  }

  bool _validateField() {
    String text = widget.controller.text;

    var result = widget.validate(text);

    if (!result.isValid) {
      setState(() {
        errorText = result.errorMessage;
      });

      return false;
    }

    return true;
  }
}
