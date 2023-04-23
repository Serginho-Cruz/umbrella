// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'income_type.dart';
import 'recorrences.dart';

class Income {
  int? id;
  String name;
  double value;
  DateTime paymentDay;
  Recorrence recorrence;
  String personName;
  IncomeType type;

  Income({
    this.id,
    required this.name,
    required this.value,
    required this.paymentDay,
    required this.recorrence,
    required this.personName,
    required this.type,
  });
}
