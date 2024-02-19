import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../repositories/iexpense_repository.dart';
import '../../repositories/iincome_repository.dart';
import '../../repositories/iinvoice_repository.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/usecases/gets/iget_balance.dart';
import '../../../errors/date_error_messages.dart';
import '../../../errors/errors.dart';
import '../../../utils/extensions.dart';

import '../../repositories/ibalance_repository.dart';
import '../../repositories/iinstallment_repository.dart';

class GetBalance implements IGetBalance {
  final IBalanceRepository balanceRepository;
  final IIncomeRepository incomeRepository;
  final IExpenseRepository expenseRepository;
  final IInvoiceRepository invoiceRepository;
  final IInstallmentRepository installmentRepository;

  GetBalance({
    required this.balanceRepository,
    required this.expenseRepository,
    required this.incomeRepository,
    required this.invoiceRepository,
    required this.installmentRepository,
  });
  @override
  Future<Result<double, Fail>> get actual =>
      balanceRepository.getActualBalanceOf(
        month: Date.today().month,
        year: Date.today().year,
      );

  @override
  Future<Result<double, Fail>> get expected =>
      balanceRepository.getExpectedBalanceOf(
        month: Date.today().month,
        year: Date.today().year,
      );

  @override
  Future<Result<double, Fail>> initialBalanceOf({
    required int month,
    required int year,
  }) async {
    final dateError = _checkMonthAndYear(month, year);
    if (dateError != null) {
      return Failure(dateError);
    }

    if (Date(year: year, month: month, day: 1).isMonthAfter(Date.today())) {
      return Failure(DateError(DateErrorMessages.dateMustBeBefore));
    }

    return balanceRepository.getInitialBalanceOf(
      month: month,
      year: year,
    );
  }

  @override
  Future<Result<double, Fail>> expectedBalanceOf({
    required int month,
    required int year,
  }) async {
    final dateError = _checkMonthAndYear(month, year);
    if (dateError != null) {
      return Failure(dateError);
    }

    final actualDate = Date.today();
    final requestedDate = Date(year: year, month: month, day: 1);
    final nextMonthDate = actualDate.add(months: 1);

    if (requestedDate.isBefore(actualDate)) {
      return balanceRepository.getExpectedBalanceOf(month: month, year: year);
    }

    if (requestedDate.isAtTheSameMonthAs(actualDate)) {
      return expected;
    }

    var results = await Future.wait([
      expected,
      incomeRepository.getSumOfIncomesWithFrequency(Frequency.daily),
      incomeRepository.getSumOfIncomesWithFrequency(Frequency.weekly),
      incomeRepository.getSumOfIncomesWithFrequency(Frequency.monthly),
      incomeRepository.getSumOfYearlyIncomesInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
      ),
      expenseRepository.getSumOfExpensesWithFrequency(Frequency.daily),
      expenseRepository.getSumOfExpensesWithFrequency(Frequency.weekly),
      expenseRepository.getSumOfExpensesWithFrequency(Frequency.monthly),
      expenseRepository.getSumOfYearlyExpensesInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
      ),
      invoiceRepository.getSumOfInvoicesInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
      ),
      installmentRepository.getSumOfInstallmentParcelsInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
      ),
    ]);

    for (var result in results) {
      if (result.isError()) {
        return result;
      }
    }

    final expectedValueOfThisMonth = results.elementAt(0).getOrDefault(0);
    final incomesDailyValue = results.elementAt(1).getOrDefault(0);
    final incomesWeeklyValue = results.elementAt(2).getOrDefault(0);
    final incomesMonthlyValue = results.elementAt(3).getOrDefault(0);
    final yearlyIncomesInRangeValue = results.elementAt(4).getOrDefault(0);
    final expensesDailyValue = results.elementAt(5).getOrDefault(0);
    final expensesWeeklyValue = results.elementAt(6).getOrDefault(0);
    final expensesMonthlyValue = results.elementAt(7).getOrDefault(0);
    final yearlyExpensesInRangeValue = results.elementAt(8).getOrDefault(0);
    final invoicesInRangeValue = results.elementAt(9).getOrDefault(0);
    final parcelsInRangeValue = results.elementAt(10).getOrDefault(0);

    var date = actualDate.copyWith(day: 1);
    var expensesSum = 0.0;
    var incomesSum = 0.0;
    var totalSum = expectedValueOfThisMonth +
        yearlyIncomesInRangeValue -
        parcelsInRangeValue -
        invoicesInRangeValue -
        yearlyExpensesInRangeValue;

    do {
      date = date.add(months: 1);

      expensesSum += _getTotalValueIn(
        month: date,
        dailyValue: expensesDailyValue,
        monthlyValue: expensesMonthlyValue,
        weeklyValue: expensesWeeklyValue,
      );
      incomesSum += _getTotalValueIn(
        month: date,
        dailyValue: incomesDailyValue,
        monthlyValue: incomesMonthlyValue,
        weeklyValue: incomesWeeklyValue,
      );
    } while (date.month != month || date.year != year);

    totalSum = totalSum + incomesSum - expensesSum;

    return Success(totalSum.roundToDecimal());
  }

  @override
  Future<Result<double, Fail>> finalBalanceOf({
    required int month,
    required int year,
  }) async {
    final dateError = _checkMonthAndYear(month, year);
    if (dateError != null) {
      return Failure(dateError);
    }

    var date = Date(day: 1, month: month, year: year);
    if (!date.isMonthBefore(Date.today())) {
      return Failure(DateError(DateErrorMessages.dateMustBeBefore));
    }

    return balanceRepository.getFinalBalanceOf(month: month, year: year);
  }

  double _getTotalValueIn({
    required Date month,
    required double dailyValue,
    required double monthlyValue,
    required double weeklyValue,
  }) =>
      dailyValue * month.totalDaysOfMonth +
      weeklyValue * month.toDateTime().totalWeeks +
      monthlyValue;

  DateError? _checkMonthAndYear(int month, int year) {
    if (month < 1 || month > 12) {
      return DateError(DateErrorMessages.invalidMonth);
    }
    if (year < 2000) {
      return DateError(DateErrorMessages.invalidYear);
    }
    return null;
  }
}
