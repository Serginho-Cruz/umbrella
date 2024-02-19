import '../domain/entities/date.dart';

extension DateTimeExtension on DateTime {
  ///Count how many weeks have in this month.
  ///A week is counted when it ends on Saturday, even if it is not complete
  int get totalWeeks {
    final DateTime withDay1 = copyWith(day: 1);
    final totalDaysOfMonth = Date.fromDateTime(this).totalDaysOfMonth;

    if (withDay1.weekday >= DateTime.friday &&
        withDay1.weekday <= DateTime.sunday &&
        totalDaysOfMonth == 31) {
      return 5;
    } else if (withDay1.weekday >= DateTime.saturday &&
        withDay1.weekday <= DateTime.sunday &&
        totalDaysOfMonth == 30) {
      return 5;
    }
    return 4;
  }

  static int totalDaysOfPeriod({
    required DateTime beginning,
    required DateTime ending,
  }) =>
      beginning.difference(ending).inDays.abs();
}

extension DoubleExtention on double {
  /// This function returns the closest value of this double, with
  /// 2 decimals numbers. Will return the same double if the value
  /// already has 2 decimals.
  ///
  /// Some examples:
  ///
  /// 123.909 -> 123.91
  ///
  /// 157.5875 -> 157.59
  ///
  /// 234.6950000000001 -> 234.70

  double roundToDecimal() {
    return (this * 100).roundToDouble() / 100;
  }
}
