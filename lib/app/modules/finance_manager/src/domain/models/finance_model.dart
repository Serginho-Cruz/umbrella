import '../entities/category.dart';
import '../entities/date.dart';
import '../entities/frequency.dart';

enum Status { okay, inTime, overdue }

extension StatusName on Status {
  String get adaptedName => switch (this) {
        Status.okay => 'Paga',
        Status.inTime => 'Em Tempo',
        Status.overdue => 'Vencida',
      };
}

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
    this.personName,
    this.paymentDate,
    required this.overdueDate,
  });
}
