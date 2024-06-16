import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/usecases/manage_income.dart';
import '../repositories/balance_repository.dart';

class ManageIncomeImpl implements ManageIncome {
  final IncomeRepository _incomeRepository;
  final BalanceRepository _balanceRepository;

  ManageIncomeImpl({
    required IncomeRepository incomeRepository,
    required BalanceRepository balanceRepository,
  })  : _incomeRepository = incomeRepository,
        _balanceRepository = balanceRepository;

  @override
  AsyncResult<int, Fail> register(Income income, Account account) async {
    final result = await _incomeRepository.create(income, account);

    if (result.isError()) return result;

    if (income.dueDate.isOfActualMonth) {
      var incrementResult = await _balanceRepository.addToExpected(
        income.totalValue,
        account,
      );

      if (incrementResult.isError()) return incrementResult.pure(0);
    }

    return result;
  }

  @override
  AsyncResult<Unit, Fail> update({
    required Income oldIncome,
    required Income newIncome,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Income>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    var incomes = <Income>[];

    var requiredDate = Date(day: 1, month: month, year: year);

    if (requiredDate.isMonthAfter(Date.today())) {
      var monthlyIncomes =
          await _incomeRepository.getByFrequency(Frequency.monthly, account);

      if (monthlyIncomes.isError()) {
        return Failure(monthlyIncomes.exceptionOrNull()!);
      }

      for (var income in monthlyIncomes.getOrDefault([])) {
        incomes.add(income.copyWith(
          id: 0,
          remainingValue: income.totalValue,
          paidValue: 0.00,
          paymentDate: null,
          dueDate: income.dueDate.copyWith(
            day: requiredDate.totalDaysOfMonth < income.dueDate.day
                ? requiredDate.totalDaysOfMonth
                : null,
            month: requiredDate.month,
            year: requiredDate.year,
          ),
        ));
      }
    }

    var requiredMonthIncomes = await _incomeRepository.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    if (requiredMonthIncomes.isError()) {
      return Failure(requiredMonthIncomes.exceptionOrNull()!);
    }

    incomes.addAll(requiredMonthIncomes.getOrDefault([]));

    return Success(incomes);
  }

  @override
  AsyncResult<Unit, Fail> delete(Income income) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
