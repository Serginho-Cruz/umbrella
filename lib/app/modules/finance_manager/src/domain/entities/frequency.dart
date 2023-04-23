enum Frequency { monthly, weekly, daily, yearly }

Map<Frequency, String> getFrequencys() {
  return {
    Frequency.monthly: "Mensal",
    Frequency.weekly: "Semanal",
    Frequency.daily: "Diária",
    Frequency.yearly: "Anual",
  };
}
