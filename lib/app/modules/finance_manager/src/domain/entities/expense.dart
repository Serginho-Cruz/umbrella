import 'expense_type.dart';
import 'frequency.dart';
import 'payment_method.dart';

class Expense {
  int id;
  double value;
  String name;
  DateTime expirationDate;
  String? personName;
  ExpenseType type;
  PaymentMethod paymentMethod;
  Frequency frequency;

  Expense({
    required this.id,
    required this.value,
    required this.name,
    required this.expirationDate,
    this.personName,
    required this.type,
    required this.paymentMethod,
    required this.frequency,
  });

  factory Expense.withoutId({
    required double value,
    required String name,
    required DateTime expirationDate,
    String? personName,
    required ExpenseType type,
    required PaymentMethod paymentMethod,
    required Frequency frequency,
  }) =>
      Expense(
        id: 0,
        value: value,
        name: name,
        expirationDate: expirationDate,
        personName: personName,
        type: type,
        paymentMethod: paymentMethod,
        frequency: frequency,
      );
}
