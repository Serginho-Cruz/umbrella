// Copied from https://github.com/yshean/input_formatting_demo

import 'package:flutter/services.dart';

TextEditingValue manipulateText(
  TextEditingValue oldValue,
  TextEditingValue newValue, {
  TextInputFormatter? textInputFormatter,
  String Function(String filteredString)? formatPattern,
}) {
  /// remove all invalid characters
  newValue = textInputFormatter != null
      ? textInputFormatter.formatEditUpdate(oldValue, newValue)
      : newValue;

  /// format original string, this step would add some separator characters
  final newText =
      formatPattern != null ? formatPattern(newValue.text) : newValue.text;

  if (newText == newValue.text) {
    return newValue;
  }

  return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty);
}
