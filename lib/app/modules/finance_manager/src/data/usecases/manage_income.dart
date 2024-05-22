import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/models/income_model.dart';
import '../../domain/usecases/manage_income.dart';

class ManageIncomeImpl implements ManageIncome {
  final IncomeRepository _incomeRepository;

  ManageIncomeImpl({required IncomeRepository incomeRepository})
      : _incomeRepository = incomeRepository;

  @override
  AsyncResult<int, Fail> register(Income income, Account account) {
    // TODO: implement register
    throw UnimplementedError();
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
  AsyncResult<List<IncomeModel>, Fail> getAllOf({
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

    var models = incomes
        .map((i) => IncomeModel.fromIncome(i, status: _determineStatus(i)));

    return Success(models.toList());
  }

  @override
  AsyncResult<Unit, Fail> delete(Income income) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Status _determineStatus(Income i) {
    if (i.remainingValue == 0.00) return Status.okay;

    if (i.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
