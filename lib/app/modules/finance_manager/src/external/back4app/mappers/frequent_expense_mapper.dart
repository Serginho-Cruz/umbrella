import '../../../domain/entities/expense.dart';
import '../parse_objects.dart';
import 'account_mapper.dart';
import 'expense_category_mapper.dart';

sealed class FrequentExpenseMapper {
  static FrequentExpenseObject toParse(Expense expense) {
    var object = FrequentExpenseObject();

    object.objectId = expense.frequentExpenseId;
    object.set('name', expense.name);
    object.set('totalValue', expense.totalValue);
    object.set('frequency', expense.frequency);
    object.set('overdueDate', expense.dueDate.toDateTime());
    object.set('personName', expense.personName);
    object.set('category', ExpenseCategoryMapper.toParse(expense.category));
    object.set('account', AccountMapper.toParse(expense.account));

    return object;
  }
}
