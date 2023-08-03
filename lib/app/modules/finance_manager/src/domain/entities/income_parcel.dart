import '../../utils/extensions.dart';
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
    required DateTime dueDate,
    required double paidValue,
    required double remainingValue,
    required double totalValue,
    DateTime? paymentDate,
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
    DateTime? dueDate,
    int? id,
    double? paidValue,
    double? remainingValue,
    DateTime? paymentDate,
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
        paymentDate?.date,
        totalValue,
      ];
}
