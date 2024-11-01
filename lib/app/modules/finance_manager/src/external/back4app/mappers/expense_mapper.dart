import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import 'account_mapper.dart';
import 'expense_category_mapper.dart';

sealed class ExpenseMapper {
  static ExpenseObject toParse(Expense expense, {bool noId = false}) {
    var object = ExpenseObject();

    if (!noId) object.objectId = expense.id;

    object.set('name', expense.name);
    object.set('totalValue', expense.totalValue);
    object.set('paidValue', expense.paidValue);
    object.set('remainingValue', expense.remainingValue);
    object.set('frequency', expense.frequency.toInt());
    object.set('overdueDate', expense.dueDate.toDateTime());
    object.set('personName', expense.personName);
    object.set('category', ExpenseCategoryMapper.toParse(expense.category));
    object.set('account', AccountMapper.toParse(expense.account));

    return object;
  }

  static Expense fromParse(ParseObject object) {
    String id = object.objectId!;
    String name = object.get('name') as String;
    double totalValue = (object.get('totalValue') as num).toDouble();
    double paidValue = (object.get('paidValue') as num).toDouble();
    double remainingValue = (object.get('remainingValue') as num).toDouble();
    String? personName = object.get('personName') as String?;
    String? frequentExpenseId = object.get('frequent')?.objectId;

    Frequency frequency =
        FrequencyMethods.fromInt(object.get('frequency') as int);

    Date dueDate = Date.fromDateTime(object.get('overdueDate') as DateTime);

    Account account =
        AccountMapper.fromParse(object.get('account') as ParseObject);

    Category category =
        ExpenseCategoryMapper.fromParse(object.get('category') as ParseObject);

    return Expense(
      id: id,
      name: name,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      frequency: frequency,
      dueDate: dueDate,
      account: account,
      category: category,
      personName: personName,
      frequentExpenseId: frequentExpenseId,
    );
  }
}
