import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/expense.dart';

abstract interface class ManageExpense {
  AsyncResult<int, Fail> register(Expense expense);
  AsyncResult<Unit, Fail> update({
    required Expense oldExpense,
    required Expense newExpense,
  });
  AsyncResult<Unit, Fail> updateValue(Expense expense, double newValue);
  AsyncResult<Unit, Fail> switchAccount(
    Expense expense,
    Account destinyAccount,
  );
  AsyncResult<List<Expense>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> delete(Expense expense);
}
