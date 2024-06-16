import '../entities/income.dart';
import 'finance_model.dart';

class IncomeModel extends FinanceModel {
  final Income income;

  IncomeModel.fromIncome(
    this.income, {
    required super.status,
  }) : super(
          id: income.id,
          name: income.name,
          overdueDate: income.dueDate,
          paidValue: income.paidValue,
          remainingValue: income.remainingValue,
          totalValue: income.totalValue,
          category: income.category,
          frequency: income.frequency,
          paymentDate: income.paymentDate,
          personName: income.personName,
        );

  Income toEntity() {
    return Income(
      id: id,
      name: name,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      dueDate: overdueDate,
      frequency: frequency,
      category: category,
      paymentDate: paymentDate,
      personName: personName,
    );
  }
}
