import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Price extends Text {
  const Price({
    super.key,
    required this.value,
    super.style,
  }) : super(
          '',
        );

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      'R\$${NumberFormat.decimalPatternDigits(locale: 'pt_BR', decimalDigits: 2).format(value)}',
      style: style,
    );
  }
}
