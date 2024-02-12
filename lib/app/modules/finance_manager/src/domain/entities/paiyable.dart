import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

abstract class Paiyable extends Equatable {
  final int id;
  final double paidValue;
  final double remainingValue;
  final Date dueDate;
  final Date? paymentDate;
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
