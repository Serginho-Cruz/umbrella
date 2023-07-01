extension DateTimeExtension on DateTime {
  String get time => '$hour:$minute';
  String get date {
    String month = this.month < 10 ? '0${this.month}' : this.month.toString();
    String day = this.day < 10 ? '0${this.day}' : this.day.toString();

    return '$year-$month-$day';
  }
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
