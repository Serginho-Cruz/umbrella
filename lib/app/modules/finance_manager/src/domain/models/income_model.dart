import '../entities/income.dart';
import 'finance_model.dart';

 class IncomeModel extends FinanceModel<Income> {
  IncomeModel.fromIncome(
    Income income, {
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
          account: income.account,
          personName: income.personName,
        );

  @override
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
      account: account,
      personName: personName,
    );
  }
}
