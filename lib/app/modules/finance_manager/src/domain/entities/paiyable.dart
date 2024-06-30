import 'package:equatable/equatable.dart';
import 'account.dart';
import 'date.dart';

abstract class Paiyable extends Equatable {
  final int id;
  final Account account;
  final double paidValue;
  final double remainingValue;
  final Date dueDate;
  final Date? paymentDate;
  final double totalValue;

  const Paiyable({
    required this.id,
    required this.account,
    required this.paidValue,
    required this.remainingValue,
    required this.dueDate,
    this.paymentDate,
    required this.totalValue,
  });
}
