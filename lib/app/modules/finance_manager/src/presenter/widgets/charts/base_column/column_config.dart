import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ColumnConfig extends BarChartRodData {
  ColumnConfig({
    required double height,
    super.color,
    super.gradient,
    super.width,
    BorderSide border = const BorderSide(width: 2.0),
  }) : super(
          toY: height,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          borderSide: border,
          fromY: 0.00,
        );
}
