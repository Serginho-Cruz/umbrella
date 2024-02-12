enum Frequency { none, monthly, weekly, daily, yearly }

extension FrequencyMethods on Frequency {
  int toInt() => index;

  static Frequency fromInt(int number) {
    if (number > 0 && number <= 4) {
      return Frequency.values[number];
    }

    return Frequency.none;
  }
}
