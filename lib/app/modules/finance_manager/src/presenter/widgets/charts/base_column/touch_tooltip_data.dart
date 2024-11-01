import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TouchTooltipData extends BarTouchTooltipData {
  TouchTooltipData({
    Color Function(int groupIndex)? resolveColor,
    BorderSide border = const BorderSide(),
    double borderRadius = 8,
    double? margin,
    EdgeInsets padding = EdgeInsets.zero,
    BarTooltipItem? Function(
      BarChartGroupData group,
      int columnIndex,
      BarChartRodData columnData,
    )? buildTooltipText,
  }) : super(
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          getTooltipColor:
              resolveColor != null ? (group) => resolveColor(group.x) : null,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipBorder: border,
          tooltipRoundedRadius: borderRadius,
          getTooltipItem: (groupData, colIndex, colData, _) {
            return buildTooltipText?.call(groupData, colIndex, colData);
          },
          tooltipPadding: padding,
          tooltipMargin: margin,
        );
}
