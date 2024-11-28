import 'package:equatable/equatable.dart';
import 'account.dart';
import 'date.dart';

abstract class Paiyable extends Equatable {
  final String id;
  final Account account;
  final double paidValue;
  final double remainingValue;
  final Date dueDate;
  final double totalValue;

  const Paiyable({
    required this.id,
    required this.account,
    required this.paidValue,
    required this.remainingValue,
    required this.dueDate,
    required this.totalValue,
  });
}
