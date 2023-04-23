import 'expense_type.dart';
import 'frequency.dart';

class Expense {
  int? id;
  double value;
  String name;
  String personName;
  ExpenseType type;
  Frequency frequency;

  Expense({
    this.id,
    required this.value,
    required this.name,
    required this.personName,
    required this.type,
    required this.frequency,
  });
}
