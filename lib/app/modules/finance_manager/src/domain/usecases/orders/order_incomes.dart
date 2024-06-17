import '../../models/income_model.dart';

abstract interface class OrderIncomes {
  List<IncomeModel> byValue(List<IncomeModel> incomes, {bool isCrescent});
  List<IncomeModel> byName(List<IncomeModel> incomes, {bool isCrescent});
  List<IncomeModel> byDueDate(List<IncomeModel> incomes, {bool isCrescent});
}
