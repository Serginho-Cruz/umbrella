enum Recorrence { monthly, weekly, daily, yearly }

Map<Recorrence, String> getRecorrences() {
  return {
    Recorrence.monthly: "Mensal",
    Recorrence.weekly: "Semanal",
    Recorrence.daily: "Diária",
    Recorrence.yearly: "Anual",
  };
}
