import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberTextController extends TextEditingController {
  double get number {
    String value = text;

    value = value.replaceAll(RegExp(r'\.'), '');
    value = value.replaceAll(RegExp(r','), '.');

    return double.parse(value);
  }

  void formatNumber() {
    text = NumberFormat.decimalPatternDigits(
      decimalDigits: 2,
      locale: 'pt_br',
    ).format(number);
  }
}
