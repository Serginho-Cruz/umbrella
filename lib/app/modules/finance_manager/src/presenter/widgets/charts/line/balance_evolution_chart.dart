import 'dart:math' show pow, log;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/date.dart';
import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_palette.dart';
import '../../../utils/umbrella_sizes.dart';
import '../../texts/small_text.dart';
import '../base_line/line_chart_base.dart';
import '../base_line/line_chart_tooltip_data.dart';
import '../charts_utils/axis_config.dart';

class BalanceEvolutionChart extends StatelessWidget {
  const BalanceEvolutionChart({
    super.key,
    required this.data,
    this.height = 400,
    this.padding = EdgeInsets.zero,
  });

  final Map<int, double> data;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: height,
        child: LineChartBase(
          data: data,
          transformData: (entry) => (entry.key.toDouble(), entry.value),
          minX: 0,
          minY: 0.00,
          maxX: Date.today().day + 1,
          leftAxisConfig: AxisConfig(
            reservedColumnSize: 100,
            axisTitleBuilder: (value, _) {
              return SmallText(CurrencyFormat.format(value));
            },
          ),
          bottomAxisConfig: AxisConfig(
            axisNameSize: 40,
            axisName: 'Dias',
            reservedColumnSize: 20,
            axisTitleBuilder: (value, _) {
              return SmallText(value.toInt().toString());
            },
          ),
          maxY: _determineMaxValue(data.values),
          showSpot: (x, _, t) {
            final isFirst = t.indexWhere((tuple) => tuple.$1 == x) == 0;
            final isLast =
                t.indexWhere((tuple) => tuple.$1 == x) == t.length - 1;

            return isFirst || isLast || x % 2 == 0;
          },
          curvedLines: true,
          linesWidth: 2,
          bottomAxisName: 'Dias',
          tooltipData: LineChartTooltipData(
            getTooltipColor: (_) => UmbrellaPalette.secondaryColor,
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    'Dia ${spot.x.toInt()}: ${CurrencyFormat.format(spot.y)}',
                    const TextStyle(
                      color: Colors.black,
                      fontSize: UmbrellaSizes.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  double _determineMaxValue(Iterable<double> numbers) {
    if (numbers.isEmpty) return 0;

    var copy = List.from(numbers);

    double biggest = copy.reduce((a, b) => a > b ? a : b);

    double base10 = pow(10, (log(biggest) / log(10)).ceil()).toDouble();

    double valorMaximo = (biggest / base10).ceil() * base10;

    int firstDigit = int.parse(biggest.toStringAsFixed(0)[0]);
    bool divideByHalf = firstDigit >= 1 && firstDigit <= 3;

    return divideByHalf ? (valorMaximo / 2) : valorMaximo;
  }
}
