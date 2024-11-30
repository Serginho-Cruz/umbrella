import '../models/expense_model.dart';
import '../models/income_model.dart';

abstract class ObtainPersonsDebts {
  Future<Map<String, double>> call({
    required List<IncomeModel> incomeModels,
    required List<ExpenseModel> expenseModels,
  });
}
