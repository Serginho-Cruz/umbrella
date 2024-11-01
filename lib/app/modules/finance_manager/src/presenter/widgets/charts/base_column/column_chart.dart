import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../texts/medium_text.dart';
import 'axis_config.dart';
import 'column_config.dart';
import 'titles_data.dart';
import 'touch_tooltip_data.dart';

class ColumnChart<Line, Column> extends StatelessWidget {
  const ColumnChart({
    super.key,
    required this.data,
    required this.transform,
    required this.width,
    required this.height,
    this.padding = EdgeInsets.zero,
    this.enableTouch = true,
    this.tooltipData,
    this.leftAxisConfig = const AxisConfig.empty(),
    this.rightAxisConfig = const AxisConfig.empty(),
    this.topAxisConfig = const AxisConfig.empty(),
    this.buildColumnTitle,
    this.bottomAxisConfig,
    this.bottomAxisNameSize,
    this.columnTitleSize,
    this.bottomAxisNameWidget,
    this.bottomAxisName,
  }) : assert((columnTitleSize == null) == (buildColumnTitle == null),
            "Both [bottomAxisNameSize] and [buildColumnTitle] must be set together");

  final Map<Line, Column> data;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool enableTouch;
  final TouchTooltipData? tooltipData;
  final AxisConfig leftAxisConfig;
  final AxisConfig topAxisConfig;
  final AxisConfig rightAxisConfig;
  final AxisConfig? bottomAxisConfig;
  final Widget Function(Line)? buildColumnTitle;
  final double? bottomAxisNameSize;
  final double? columnTitleSize;
  final String? bottomAxisName;
  final Widget? bottomAxisNameWidget;
  final ColumnConfig Function(int index, MapEntry<Line, Column>) transform;

  @override
  Widget build(BuildContext context) {
    final List<ColumnConfig> columnsList = data.entries.indexed
        .map<ColumnConfig>((tuple) => transform(tuple.$1, tuple.$2))
        .toList();
    int columnIndex = 0;

    AxisConfig? bottomAxis;

    if (buildColumnTitle == null && bottomAxisConfig == null) {
      bottomAxis = const AxisConfig.empty();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: BarChart(
          BarChartData(
            minY: 0.00,
            alignment: BarChartAlignment.spaceEvenly,
            barTouchData: BarTouchData(
              touchTooltipData: tooltipData,
              enabled: enableTouch,
              mouseCursorResolver: (event, response) {
                return SystemMouseCursors.click;
              },
            ),
            titlesData: TitlesData(
              leftConfig: leftAxisConfig,
              rightConfig: rightAxisConfig,
              topConfig: topAxisConfig,
              bottomConfig: bottomAxis ??
                  bottomAxisConfig ??
                  AxisConfig(
                    axisNameSize: bottomAxisNameSize!,
                    axisName: bottomAxisName,
                    axisNameWidget: bottomAxisName != null
                        ? MediumText.bold(
                            bottomAxisName!,
                            fontStyle: FontStyle.italic,
                          )
                        : null,
                    reservedColumnSize: this.columnTitleSize,
                    axisTitleBuilder: (value, _) {
                      Line item = data.keys.elementAt(value.toInt() - 1);
                      return buildColumnTitle!.call(item);
                    },
                  ),
            ),
            barGroups: columnsList.map(
              (column) {
                columnIndex++;
                return BarChartGroupData(
                  x: columnIndex,
                  barRods: [column],
                );
              },
            ).toList(),
            gridData: const FlGridData(
              drawVerticalLine: false,
              drawHorizontalLine: true,
            ),
          ),
        ),
      ),
    );
  }
}
