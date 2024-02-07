import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Price extends StatelessWidget {
  const Price({
    super.key,
    required this.value,
    this.style,
  });

  final double value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      'R\$${NumberFormat.decimalPatternDigits(locale: 'pt_BR', decimalDigits: 2).format(value)}',
      style: style,
    );
  }
}
