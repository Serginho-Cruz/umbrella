import 'package:flutter/material.dart';

import '../../../../domain/models/status.dart';
import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_palette.dart';
import '../../icons/status_icon.dart';
import '../../texts/medium_text.dart';
import '../../texts/small_text.dart';
import '../base_pie/pie_chart_base.dart';
import '../base_pie/pie_slice_config.dart';

class StatusPieChart extends StatelessWidget {
  const StatusPieChart({
    super.key,
    required this.data,
    required this.graphSize,
    double? legendSize,
  }) : legendSize = legendSize ?? graphSize - 60;

  final Map<Status, double> data;
  final double graphSize;
  final double legendSize;

  final Map<Status, Color> _pieColors = const {
    Status.okay: Colors.lightGreen,
    Status.inTime: Colors.lightBlue,
    Status.overdue: Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return PieChartBase(
      data: data,
      transform: (index, entry, isTouched) => PieSliceConfig(
        radius: isTouched ? 150 : 130,
        value: entry.value,
        color: _pieColors[entry.key],
        titleWidget: Transform.scale(
          scale: isTouched ? 1.2 : 1,
          child: StatusIcon(status: entry.key, size: 40),
        ),
      ),
      graphSize: graphSize,
      buildTooltip: (entry) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
          color: UmbrellaPalette.primaryColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: kElevationToShadow[2],
        ),
        child: MediumText(CurrencyFormat.format(entry.value)),
      ),
      buildLegend: (entry) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: _pieColors[entry.key],
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const SizedBox.square(dimension: 24),
          ),
          const SizedBox(width: 10),
          SmallText.bold(entry.key.adaptedName),
        ],
      ),
      centerRadius: 20.0,
      legendSize: legendSize,
    );
  }
}
