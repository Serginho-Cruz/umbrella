enum Frequency { none, monthly, weekly, daily, yearly }

int frequencyToInt(Frequency frequency) {
  var map = <Frequency, int>{
    Frequency.monthly: 1,
    Frequency.weekly: 2,
    Frequency.daily: 3,
    Frequency.yearly: 4,
  };

  return map[frequency] ?? 0;
}

Frequency frequencyFromInt(int number) {
  var map = <int, Frequency>{
    1: Frequency.monthly,
    2: Frequency.weekly,
    3: Frequency.daily,
    4: Frequency.yearly,
  };

  return map[number] ?? Frequency.none;
}
