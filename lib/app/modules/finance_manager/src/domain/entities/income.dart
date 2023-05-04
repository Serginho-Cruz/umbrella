import 'frequency.dart';
import 'income_type.dart';

class Income {
  int id;
  String name;
  double value;
  DateTime paymentDay;
  Frequency frequency;
  String? personName;
  IncomeType type;

  Income({
    required this.id,
    required this.name,
    required this.value,
    required this.paymentDay,
    required this.frequency,
    this.personName,
    required this.type,
  });

  factory Income.withoutId({
    required String name,
    required double value,
    required DateTime paymentDay,
    required Frequency frequency,
    String? personName,
    required IncomeType type,
  }) {
    return Income(
      id: 0,
      frequency: frequency,
      name: name,
      paymentDay: paymentDay,
      personName: personName,
      type: type,
      value: value,
    );
  }
}
