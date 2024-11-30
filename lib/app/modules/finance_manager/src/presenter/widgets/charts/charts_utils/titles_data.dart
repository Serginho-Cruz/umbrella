import 'package:fl_chart/fl_chart.dart';

import 'axis_config.dart';

class TitlesData extends FlTitlesData {
  TitlesData({
    AxisConfig bottomConfig = const AxisConfig.empty(),
    AxisConfig topConfig = const AxisConfig.empty(),
    AxisConfig leftConfig = const AxisConfig.empty(),
    AxisConfig rightConfig = const AxisConfig.empty(),
  }) : super(
          topTitles: topConfig,
          bottomTitles: bottomConfig,
          leftTitles: leftConfig,
          rightTitles: rightConfig,
        );
}
