import '../entities/date.dart';

enum Status { okay, inTime, overdue }

abstract class FinanceModel {
  final int id;
  final String name;
  final double totalValue;
  final double paidValue;
  final double remainingValue;
  final Status status;
  final Date overdueDate;

  FinanceModel({
    required this.id,
    required this.name,
    required this.totalValue,
    required this.paidValue,
    required this.remainingValue,
    required this.status,
    required this.overdueDate,
  });
}
