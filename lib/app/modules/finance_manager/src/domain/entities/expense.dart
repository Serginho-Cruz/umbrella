import 'expense_type.dart';
import 'recorrences.dart';

class Expense {
  int? id;
  double value;
  String name;
  String personName;
  ExpenseType type;
  Recorrence recorrence;

  Expense({
    this.id,
    required this.value,
    required this.name,
    required this.personName,
    required this.type,
    required this.recorrence,
  });
}
