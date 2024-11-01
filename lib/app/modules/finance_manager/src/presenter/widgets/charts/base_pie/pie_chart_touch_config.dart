import 'package:fl_chart/fl_chart.dart';

class PieChartTouchConfig extends PieTouchData {
  PieChartTouchConfig({
    super.enabled,
    super.longPressDuration = const Duration(milliseconds: 500),
    void Function(FlTouchEvent, PieTouchResponse?)? onSlicePressed,
    void Function(FlTouchEvent, PieTouchResponse?)? onSlicePressEnd,
  }) : super(
          touchCallback: (event, resp) {
            if (event is! FlLongPressEnd && event is! FlLongPressStart) {
              return;
            }

            if (event is FlLongPressEnd) {
              onSlicePressEnd?.call(event, resp);
              return;
            }

            onSlicePressed?.call(event, resp);
          },
        );
}
