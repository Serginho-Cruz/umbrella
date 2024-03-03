enum Frequency { none, monthly, yearly }

extension FrequencyMethods on Frequency {
  int toInt() => index;

  String get name => switch (this) {
        Frequency.none => "Não Frequente",
        Frequency.monthly => "Mensal",
        Frequency.yearly => "Anual",
      };

  static Frequency fromInt(int number) {
    if (number > 0 && number <= 2) {
      return Frequency.values[number];
    }

    return Frequency.none;
  }
}
