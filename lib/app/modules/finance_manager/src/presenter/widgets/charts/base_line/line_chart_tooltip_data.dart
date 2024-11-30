import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartTooltipData extends LineTouchTooltipData {
  LineChartTooltipData({
    super.getTooltipColor,
    required super.getTooltipItems,
  }) : super(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipRoundedRadius: 2,
          tooltipMargin: 20,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorder: const BorderSide(),
        );
}
