import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Price extends Text {
  Price({
    super.key,
    required this.value,
    this.style,
  }) : super(
          '',
        );

  final double value;

  @override
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      'R\$${NumberFormat.decimalPatternDigits(locale: 'pt_BR', decimalDigits: 2).format(value)}',
      style: style,
    );
  }
}
