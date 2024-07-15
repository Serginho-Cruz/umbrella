import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/entities/paiyable.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/invoice_repository.dart';
import '../../../domain/usecases/gets/get_balance.dart';
import '../../../errors/errors.dart';

import '../../repositories/balance_repository.dart';
import '../../repositories/installment_repository.dart';

class GetBalanceImpl implements GetBalance {
  final BalanceRepository balanceRepository;
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;
  final InvoiceRepository invoiceRepository;
  final InstallmentRepository installmentRepository;
  final AccountRepository accountRepository;

  GetBalanceImpl({
    required this.balanceRepository,
    required this.expenseRepository,
    required this.incomeRepository,
    required this.invoiceRepository,
    required this.installmentRepository,
    required this.accountRepository,
  });

  @override
  AsyncResult<double, Fail> initialOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    if (Date(day: 1, month: month, year: year).isMonthAfter(Date.today())) {
      return expectedOf(month: month - 1, year: year, account: account);
    }

    var initialBalance = await balanceRepository.getInitialOf(
      month: month,
      year: year,
      account: account,
    );

    return initialBalance;
  }

  @override
  AsyncResult<double, Fail> expectedOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    final today = Date.today();
    var requestedDate = Date(year: year, month: month, day: 1);
    requestedDate = requestedDate.copyWith(day: requestedDate.totalDaysOfMonth);

    final nextMonthDate = today.add(months: 1);

    if (requestedDate.isMonthBefore(today)) return const Success(0.00);

    if (requestedDate.isAtTheSameMonthAs(today)) {
      return balanceRepository.getExpectedOf(
        month: month,
        year: year,
        account: account,
      );
    }

    var results = await Future.wait([
      incomeRepository.getByFrequency(Frequency.monthly, account),
      incomeRepository.getByFrequencyInRange(
        frequency: Frequency.none,
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
        account: account,
      ),
      incomeRepository.getByFrequencyInRange(
        frequency: Frequency.yearly,
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
        account: account,
      ),
      expenseRepository.getByFrequency(Frequency.monthly, account),
      expenseRepository.getByFrequencyInRange(
        frequency: Frequency.none,
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
        account: account,
      ),
      expenseRepository.getByFrequencyInRange(
        frequency: Frequency.yearly,
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
        account: account,
      ),
      invoiceRepository.getInRange(
        inferiorLimit: nextMonthDate,
        upperLimit: requestedDate,
        account: account,
      ),
    ]);

    final expectedBalanceOfActualMonth = await balanceRepository.getExpectedOf(
      month: today.month,
      year: today.year,
      account: account,
    );

    if (expectedBalanceOfActualMonth.isError()) {
      return expectedBalanceOfActualMonth;
    }

    for (var result in results) {
      if (result.isError()) {
        return result.pure(2);
      }
    }

    final monthlyIncomes = results.elementAt(0).getOrDefault(<Income>[]);
    final normalIncomes = results.elementAt(1).getOrDefault(<Income>[]);
    final yearlyIncomes = results.elementAt(2).getOrDefault(<Income>[]);

    final monthlyExpenses = results.elementAt(3).getOrDefault(<Expense>[]);
    final normalExpenses = results.elementAt(4).getOrDefault(<Expense>[]);
    final yearlyExpenses = results.elementAt(5).getOrDefault(<Expense>[]);

    final invoices = results.elementAt(6).getOrDefault(<Invoice>[]);

    final incomesInRangeValue =
        (_sumValues(normalIncomes) + _sumValues(yearlyIncomes))
            .roundToDecimal();

    final expensesInRangeValue =
        (_sumValues(normalExpenses) + _sumValues(yearlyExpenses))
            .roundToDecimal();

    final invoicesInRangeValue = _sumValues(invoices);

    final monthlyBalance =
        (_sumValues(monthlyIncomes) - _sumValues(monthlyExpenses))
            .roundToDecimal();

    var date = today.copyWith(day: 1);

    double durationBalance = 0.00;

    date = date.add(months: 1);

    while (!date.isMonthAfter(requestedDate)) {
      durationBalance += monthlyBalance;

      date = date.add(months: 1);
    }

    final totalSum = expectedBalanceOfActualMonth.getOrDefault(0.00) +
        durationBalance +
        incomesInRangeValue -
        expensesInRangeValue -
        invoicesInRangeValue;

    return Success(totalSum.roundToDecimal());
  }

  @override
  AsyncResult<double, Fail> finalOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    var requestedDate = Date(year: year, month: month, day: 1);

    if (!requestedDate.isMonthBefore(Date.today())) {
      return const Success(0.00);
    }

    return balanceRepository.getFinalOf(
      month: month,
      year: year,
      account: account,
    );
  }

  double _sumValues(List<Paiyable> paiyables) {
    double sum = 0.00;

    for (var paiyable in paiyables) {
      sum += paiyable.remainingValue;
    }

    return sum;
  }
}
