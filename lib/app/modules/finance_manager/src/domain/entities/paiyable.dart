import 'package:equatable/equatable.dart';

abstract class Paiyable with EquatableMixin {
  int id;
  double paidValue;
  double remainingValue;
  DateTime dueDate;
  DateTime? paymentDate;
  double totalValue;

  Paiyable({
    required this.id,
    required this.paidValue,
    required this.remainingValue,
    required this.dueDate,
    this.paymentDate,
    required this.totalValue,
  });
}
