import '../entities/account.dart';
import '../entities/category.dart';
import '../entities/date.dart';
import '../entities/frequency.dart';
import 'status.dart';

abstract class FinanceModel {
  final int id;
  final String name;
  final double totalValue;
  final double paidValue;
  final double remainingValue;
  final Category category;
  final Status status;
  final Date overdueDate;
  final Frequency frequency;
  final Account account;
  final String? personName;
  final Date? paymentDate;

  FinanceModel({
    required this.id,
    required this.name,
    required this.totalValue,
    required this.paidValue,
    required this.remainingValue,
    required this.status,
    required this.category,
    required this.frequency,
    required this.account,
    this.personName,
    this.paymentDate,
    required this.overdueDate,
  });
}
