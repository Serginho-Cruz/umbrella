import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_paiyable.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_type.dart';
import '../../../domain/usecases/filters/filter_expenses.dart';

class FilterExpensesImpl extends FilterPaiyable<Expense>
    implements FilterExpenses {
  @override
  List<Expense> byName({
    required List<Expense> expenses,
    required String searchName,
  }) =>
      expenses
          .where((e) => e.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();

  @override
  List<Expense> byType({
    required List<Expense> expenses,
    required ExpenseType type,
  }) =>
      expenses.where((e) => e.type == type).toList();
}
