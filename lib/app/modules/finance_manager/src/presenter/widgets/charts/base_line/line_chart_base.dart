import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/charts/base_line/line_chart_tooltip_data.dart';

import '../../../utils/umbrella_palette.dart';
import '../../texts/medium_text.dart';
import '../charts_utils/axis_config.dart';
import '../charts_utils/titles_data.dart';

class LineChartBase<X, Y> extends StatelessWidget {
  const LineChartBase({
    super.key,
    this.minX = 0,
    this.maxX,
    this.minY = 0,
    this.maxY,
    required this.tooltipData,
    this.enableTouch = true,
    this.leftAxisConfig = const AxisConfig.empty(),
    this.topAxisConfig = const AxisConfig.empty(),
    this.rightAxisConfig = const AxisConfig.empty(),
    this.bottomAxisConfig,
    this.bottomTitleSize,
    this.bottomAxisNameSize,
    this.bottomAxisName,
    this.buildLineTitle,
    required this.data,
    required this.transformData,
    this.linesWidth = 1,
    this.curvedLines = true,
    this.showSpot,
    this.lineColor = UmbrellaPalette.balanceChartLineColor,
  });

  final double minX, minY;
  final double? maxX, maxY;
  final double linesWidth;
  final bool curvedLines;
  final LineChartTooltipData tooltipData;
  final bool enableTouch;
  final AxisConfig leftAxisConfig;
  final AxisConfig topAxisConfig;
  final AxisConfig rightAxisConfig;
  final AxisConfig? bottomAxisConfig;
  final double? bottomTitleSize;
  final double? bottomAxisNameSize;
  final String? bottomAxisName;
  final Widget Function(X)? buildLineTitle;

  final Map<X, Y> data;
  final (
    double x,
    double y,
  )
      Function(MapEntry<X, Y>) transformData;
  final bool Function(
    double x,
    double y,
    List<(double, double)> transformedData,
  )? showSpot;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        minX: minX,
        maxX: maxX,
        lineTouchData: LineTouchData(
          touchTooltipData: tooltipData,
          enabled: enableTouch,
        ),
        titlesData: TitlesData(
          leftConfig: leftAxisConfig,
          bottomConfig: _resolveBottomAxis(),
          rightConfig: rightAxisConfig,
          topConfig: topAxisConfig,
        ),
        lineBarsData: [
          LineChartBarData(
            barWidth: linesWidth,
            isCurved: curvedLines,
            dotData: FlDotData(
              checkToShowDot: (spot, barData) {
                var transformed = barData.spots.map((spot) => (spot.x, spot.y));
                double x = spot.x, y = spot.y;

                return showSpot?.call(x, y, transformed.toList()) ?? true;
              },
            ),
            color: lineColor,
            preventCurveOverShooting: true,
            spots: data.entries.map((entry) {
              var coordinate = transformData(entry);
              return FlSpot(coordinate.$1, coordinate.$2);
            }).toList(),
          ),
        ],
      ),
    );
  }

  AxisConfig _resolveBottomAxis() {
    if (bottomAxisConfig == null && buildLineTitle == null) {
      return const AxisConfig.empty();
    }
    return bottomAxisConfig ??
        AxisConfig(
          axisName: bottomAxisName,
          axisNameSize: bottomAxisNameSize!,
          axisNameWidget: bottomAxisName != null
              ? MediumText.bold(
                  bottomAxisName!,
                  fontStyle: FontStyle.italic,
                )
              : null,
          reservedColumnSize: bottomTitleSize,
          axisTitleBuilder: (value, _) {
            X item = data.keys.elementAt(value.toInt() - 1);
            return buildLineTitle!.call(item);
          },
        );
  }
}
