// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'expense_type.dart';
import 'recorrences.dart';

class Expense {
  int id;
  double value;
  String name;
  String personName;
  ExpenseType type;
  Recorrence recorrence;

  Expense({
    required this.id,
    required this.value,
    required this.name,
    required this.personName,
    required this.type,
    required this.recorrence,
  });
}
