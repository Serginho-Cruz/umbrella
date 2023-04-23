import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/expense.dart';
import '../entities/expense_parcel.dart';

abstract class IMaintainExpense {
  Result<void, Fail> register(Expense expense);

  Result<void, Fail> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
    bool updateThisMonthParcel = false,
  });

  Result<List<ExpenseParcel>, Fail> getAll(int month);

  Result<void, Fail> reverseExpense(ExpenseParcel parcel);

  Result<void, Fail> delete({
    required ExpenseParcel expense,
    bool deleteExpense = false,
    bool deleteThisMonthToo = false,
  });
}
