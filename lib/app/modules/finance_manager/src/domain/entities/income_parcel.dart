import '../../utils/extensions.dart';
import 'income.dart';
import 'paiyable.dart';

class IncomeParcel extends Paiyable {
  Income income;

  IncomeParcel({
    required this.income,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.paymentDate,
    required super.totalValue,
  });

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
