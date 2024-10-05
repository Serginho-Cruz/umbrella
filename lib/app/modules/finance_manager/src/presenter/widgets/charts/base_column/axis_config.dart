import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../texts/medium_text.dart';

export 'package:fl_chart/fl_chart.dart' show SideTitleWidget;

class AxisConfig extends AxisTitles {
  const AxisConfig.empty() : super();

  AxisConfig({
    required super.axisNameSize,
    Widget? axisNameWidget,
    String? axisName,
    double? reservedColumnSize,
    Widget Function(double value, TitleMeta meta)? axisTitleBuilder,
  }) : super(
          axisNameWidget: axisNameWidget ??=
              axisName != null ? MediumText.bold(axisName) : null,
          sideTitles: SideTitles(
            maxIncluded: false,
            getTitlesWidget: axisTitleBuilder != null
                ? (value, meta) => axisTitleBuilder(value, meta)
                : defaultGetTitle,
            reservedSize: reservedColumnSize ?? 22,
            showTitles: true,
          ),
        );
}
