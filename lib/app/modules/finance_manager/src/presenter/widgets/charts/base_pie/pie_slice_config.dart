import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../utils/umbrella_sizes.dart';

class PieSliceConfig extends PieChartSectionData {
  PieSliceConfig({
    required double value,
    required double radius,
    super.color,
    super.gradient,
    super.title,
    Widget? titleWidget,
    double? titleOffsetInPercent,
  }) : super(
          value: value,
          borderSide: const BorderSide(width: 2.0),
          badgeWidget: titleWidget,
          badgePositionPercentageOffset: titleOffsetInPercent,
          titlePositionPercentageOffset: titleOffsetInPercent,
          showTitle: title != null,
          radius: radius,
          titleStyle: const TextStyle(
            color: Colors.black,
            fontSize: UmbrellaSizes.small,
          ),
        );
}
