import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'income.dart';
import 'paiyable.dart';

class IncomeParcel extends Paiyable {
  final Income income;

  const IncomeParcel({
    required this.income,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.paymentDate,
    required super.totalValue,
  });

  factory IncomeParcel.withoutId({
    required Income income,
    required Date dueDate,
    required double paidValue,
    required double remainingValue,
    required double totalValue,
    Date? paymentDate,
  }) =>
      IncomeParcel(
        income: income,
        dueDate: dueDate,
        id: 0,
        paymentDate: paymentDate,
        paidValue: paidValue,
        remainingValue: remainingValue,
        totalValue: totalValue,
      );

  IncomeParcel copyWith({
    Income? income,
    Date? dueDate,
    int? id,
    double? paidValue,
    double? remainingValue,
    Date? paymentDate,
    double? totalValue,
  }) {
    return IncomeParcel(
      id: id ?? this.id,
      dueDate: dueDate ?? this.dueDate,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      totalValue: totalValue ?? this.totalValue,
      paymentDate: paymentDate ?? this.paymentDate,
      income: income ?? this.income,
    );
  }

  @override
  List<Object?> get props => [
        income,
        id,
        paidValue,
        remainingValue,
        paymentDate,
        totalValue,
      ];
}
