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
