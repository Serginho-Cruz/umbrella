import 'package:equatable/equatable.dart';

abstract class Paiyable extends Equatable {
  final int id;
  final double paidValue;
  final double remainingValue;
  final DateTime dueDate;
  final DateTime? paymentDate;
  final double totalValue;

  const Paiyable({
    required this.id,
    required this.paidValue,
    required this.remainingValue,
    required this.dueDate,
    this.paymentDate,
    required this.totalValue,
  });
}
