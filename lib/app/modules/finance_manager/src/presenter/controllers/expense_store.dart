import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/usecases/manage_expense.dart';
import '../../errors/errors.dart';

class ExpenseStore extends Store<List<ExpenseModel>> {
  ExpenseStore(this._manageExpense) : super([]);

  final ManageExpense _manageExpense;

  AsyncResult<int, Fail> register(Expense expense, Account account) async {
    var result = await _manageExpense.register(expense, account);

    return result;
  }

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty) return;

    setLoading(true);

    var list = List.generate(
        accounts.length,
        (i) => _manageExpense.getAllOf(
            month: month, year: year, account: accounts[i]));

    var results = await Future.wait(list);

    var models = <ExpenseModel>[];

    for (int i = 0; i < accounts.length; i++) {
      var result = results[i];

      if (result.isError()) {
        setError(result.exceptionOrNull()!);
        setLoading(false);

        return;
      }

      var expenses = result.getOrDefault([]);

      models.addAll(expenses.map((e) => _toModel(e)));
    }

    update(models);
    setLoading(false);
  }

  Future<void> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    setLoading(true);

    var expensesResult = await _manageExpense.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    expensesResult.fold((expenses) {
      var models = expenses.map((e) => _toModel(e));

      update(models.toList());
    }, (fail) {
      setError(fail);
    });

    setLoading(false);
  }

  ExpenseModel _toModel(Expense e) {
    return ExpenseModel.fromExpense(e, status: _determineExpenseStatus(e));
  }

  Status _determineExpenseStatus(Expense e) {
    if (e.remainingValue == 0.00) return Status.okay;

    if (e.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
