import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';
import '../../domain/entities/account.dart';
import '../repositories/balance_repository.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

import '../../domain/usecases/manage_expense.dart';
import '../repositories/expense_repository.dart';

class ManageExpenseImpl implements ManageExpense {
  final ExpenseRepository _expenseRepository;
  final BalanceRepository _balanceRepository;

  ManageExpenseImpl({
    required ExpenseRepository expenseRepository,
    required BalanceRepository balanceRepository,
  })  : _expenseRepository = expenseRepository,
        _balanceRepository = balanceRepository;

  @override
  AsyncResult<int, Fail> register(Expense expense) async {
    final result = await _expenseRepository.create(expense);

    if (result.isError()) return result;

    if (expense.dueDate.isOfActualMonth) {
      var decrementResult = await _balanceRepository.subtractFromExpected(
        expense.totalValue,
        expense.account,
      );

      if (decrementResult.isError()) return decrementResult.pure(0);
    }

    return result;
  }

  @override
  AsyncResult<Unit, Fail> update({
    required Expense oldExpense,
    required Expense newExpense,
  }) async {
    if (oldExpense == newExpense) return const Success(unit);

    var updateRes = await _expenseRepository.update(newExpense);

    if (updateRes.isError()) return updateRes;

    if (newExpense.dueDate.isOfActualMonth &&
        !oldExpense.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.subtractFromExpected(
        newExpense.remainingValue,
        newExpense.account,
      );

      if (res.isError()) return res;
    } else if (!newExpense.dueDate.isOfActualMonth &&
        oldExpense.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.addToExpected(
        newExpense.remainingValue,
        newExpense.account,
      );

      if (res.isError()) return res;
    }

    return updateRes;
  }

  @override
  AsyncResult<List<Expense>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    var expenses = <Expense>[];

    var requiredDate = Date(day: 1, month: month, year: year);

    if (requiredDate.isMonthAfter(Date.today())) {
      var monthlyExpenses =
          await _expenseRepository.getByFrequency(Frequency.monthly, account);

      if (monthlyExpenses.isError()) {
        return Failure(monthlyExpenses.exceptionOrNull()!);
      }

      for (var expense in monthlyExpenses.getOrDefault([])) {
        expenses.add(expense.copyWith(
          id: 0,
          remainingValue: expense.totalValue,
          paidValue: 0.00,
          paymentDate: null,
          dueDate: expense.dueDate.copyWith(
            day: requiredDate.totalDaysOfMonth < expense.dueDate.day
                ? requiredDate.totalDaysOfMonth
                : null,
            month: requiredDate.month,
            year: requiredDate.year,
          ),
        ));
      }
    }

    var requiredMonthExpenses = await _expenseRepository.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    if (requiredMonthExpenses.isError()) {
      return Failure(requiredMonthExpenses.exceptionOrNull()!);
    }

    expenses.addAll(requiredMonthExpenses.getOrDefault([]));

    return Success(expenses);
  }

  @override
  AsyncResult<Unit, Fail> delete(Expense expense) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> switchAccount(
    Expense expense,
    Account destinyAccount,
  ) async {
    if (expense.account.id == destinyAccount.id) return const Success(unit);

    var updatedExpense = expense.copyWith(account: destinyAccount);

    var updateRes = await _expenseRepository.update(updatedExpense);

    if (updateRes.isError()) return updateRes;

    var updates = await Future.wait([
      _balanceRepository.addToExpected(
        expense.remainingValue,
        expense.account,
      ),
      _balanceRepository.subtractFromExpected(
        expense.remainingValue,
        destinyAccount,
      ),
    ]);

    for (var update in updates) {
      if (update.isError()) return update;
    }

    return updateRes;
  }

  @override
  AsyncResult<Unit, Fail> updateValue(Expense expense, double newValue) async {
    if (expense.totalValue == newValue) return const Success(unit);

    double difference = (newValue - expense.totalValue).roundToDecimal();

    var updatedExpense = expense.copyWith(
      totalValue: newValue,
      remainingValue: (expense.remainingValue + difference).roundToDecimal(),
      paidValue: expense.paidValue > newValue ? newValue : expense.paidValue,
    );

    var updateRes = await _expenseRepository.update(updatedExpense);

    if (updateRes.isError()) return updateRes;

    if (expense.paidValue > newValue) {
      double paidDifference = (expense.paidValue - newValue).roundToDecimal();

      var res = await _balanceRepository.addToActual(
        paidDifference,
        expense.account,
      );

      if (res.isError()) return res;

      //TODO: Call Refund usecase
    }

    if (expense.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.subtractFromExpected(
        difference,
        expense.account,
      );

      if (res.isError()) return res;
    }

    return updateRes;
  }
}
