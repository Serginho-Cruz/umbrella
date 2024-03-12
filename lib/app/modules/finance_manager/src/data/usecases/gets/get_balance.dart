import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../repositories/iexpense_repository.dart';
import '../../repositories/iincome_repository.dart';
import '../../repositories/iinvoice_repository.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/usecases/gets/iget_balance.dart';
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
    final actualDate = Date.today();
    final requestedDate = Date(year: year, month: month, day: 1);
    final nextMonthDate = actualDate.add(months: 1);

    if (requestedDate.isAtTheSameMonthAs(actualDate)) return expected;

    var results = await Future.wait([
      expected,
      incomeRepository.getSumOfIncomesWithFrequency(Frequency.monthly),
      incomeRepository.getSumOfYearlyIncomesInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
      ),
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

    final expectedValueOfThisMonth = results.elementAt(0).getOrDefault(0.00);
    final incomesMonthlyValue = results.elementAt(1).getOrDefault(0.00);
    final yearlyIncomesInRangeValue = results.elementAt(2).getOrDefault(0.00);
    final expensesMonthlyValue = results.elementAt(3).getOrDefault(0.00);
    final yearlyExpensesInRangeValue = results.elementAt(4).getOrDefault(0.00);
    final invoicesInRangeValue = results.elementAt(5).getOrDefault(0.00);
    final parcelsInRangeValue = results.elementAt(6).getOrDefault(0.00);

    var date = actualDate.copyWith(day: 1);
    var expensesSum = 0.00;
    var incomesSum = 0.00;
    var totalSum = expectedValueOfThisMonth +
        yearlyIncomesInRangeValue -
        parcelsInRangeValue -
        invoicesInRangeValue -
        yearlyExpensesInRangeValue;

    date = date.add(months: 1);

    while (!date.isMonthAfter(requestedDate)) {
      expensesSum += expensesMonthlyValue;
      incomesSum += incomesMonthlyValue;

      date = date.add(months: 1);
    }

    totalSum = totalSum + incomesSum - expensesSum;

    return Success(totalSum.roundToDecimal());
  }

  @override
  Future<Result<double, Fail>> finalBalanceOf({
    required int month,
    required int year,
  }) async {
    return balanceRepository.getFinalBalanceOf(month: month, year: year);
  }
}
