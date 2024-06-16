import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/expense.dart';

abstract interface class ManageExpense {
  AsyncResult<int, Fail> register(Expense expense, Account account);
  AsyncResult<Unit, Fail> update({
    required Expense oldExpense,
    required Expense newExpense,
    required Account account,
  });
  AsyncResult<List<Expense>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> delete(Expense expense, Account account);
}
