import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../../domain/entities/account.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/invoice_repository.dart';
import '../../../domain/usecases/gets/iget_balance.dart';
import '../../../errors/errors.dart';

import '../../repositories/balance_repository.dart';
import '../../repositories/installment_repository.dart';

class GetBalance implements IGetBalance {
  final BalanceRepository balanceRepository;
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;
  final InvoiceRepository invoiceRepository;
  final InstallmentRepository installmentRepository;
  final AccountRepository accountRepository;

  GetBalance({
    required this.balanceRepository,
    required this.expenseRepository,
    required this.incomeRepository,
    required this.invoiceRepository,
    required this.installmentRepository,
    required this.accountRepository,
  });

  @override
  Future<Result<double, Fail>> initialBalanceOf({
    required int month,
    required int year,
    Account? account,
  }) async {
    if (Date(day: 1, month: month, year: year).isMonthAfter(Date.today())) {
      return expectedBalanceOf(month: month, year: year, account: account);
    }

    List<Account> accounts = [];

    if (account != null) {
      accounts.add(account);
    } else {
      var accountsFetchResult = await accountRepository.getAll();

      if (accountsFetchResult.isError()) {
        return accountsFetchResult.map((_) => 0.00);
      }

      accounts.addAll(accountsFetchResult.getOrDefault([]));
    }

    double initialBalance = 0.00;
    for (var account in accounts) {
      var fetchResult = await balanceRepository.getInitialBalanceOf(
        month: month,
        year: year,
        account: account,
      );

      if (fetchResult.isError()) return fetchResult;
      initialBalance += fetchResult.getOrDefault(0.00);
    }

    return initialBalance.toSuccess();
  }

  @override
  Future<Result<double, Fail>> expectedBalanceOf({
    required int month,
    required int year,
    Account? account,
  }) async {
    // List<Account> accounts = [];

    // if (account != null) {
    //   accounts.add(account);
    // } else {
    //   var accountsFetchResult = await accountRepository.getAll();

    //   if (accountsFetchResult.isError()) {
    //     return accountsFetchResult.map((_) => 0.00);
    //   }

    //   accounts.addAll(accountsFetchResult.getOrDefault([]));
    // }

    // final today = Date.today();
    // final requestedDate = Date(year: year, month: month, day: 1);
    // final nextMonthDate = today.add(months: 1);

    // for (var account in accounts) {}

    // if (requestedDate.isAtTheSameMonthAs(today)) {
    //   return balanceRepository.getExpectedBalanceOf(
    //     month: month,
    //     year: year,
    //     account: account,
    //   );
    // }

    // var results = await Future.wait([
    //   expected,
    //   incomeRepository.getSumOfIncomesWithFrequency(Frequency.monthly),
    //   incomeRepository.getSumOfYearlyIncomesInRange(
    //     inferiorLimit: nextMonthDate,
    //     upperLimit: requestedDate,
    //   ),
    //   expenseRepository.getSumOfExpensesWithFrequency(Frequency.monthly),
    //   expenseRepository.getSumOfYearlyExpensesInRange(
    //     inferiorLimit: nextMonthDate,
    //     upperLimit: requestedDate,
    //   ),
    //   invoiceRepository.getSumOfInvoicesInRange(
    //     inferiorLimit: nextMonthDate,
    //     upperLimit: requestedDate,
    //   ),
    //   installmentRepository.getSumOfInstallmentParcelsInRange(
    //     inferiorLimit: nextMonthDate,
    //     upperLimit: requestedDate,
    //   ),
    // ]);

    // for (var result in results) {
    //   if (result.isError()) {
    //     return result;
    //   }
    // }

    // final expectedValueOfThisMonth = results.elementAt(0).getOrDefault(0.00);
    // final incomesMonthlyValue = results.elementAt(1).getOrDefault(0.00);
    // final yearlyIncomesInRangeValue = results.elementAt(2).getOrDefault(0.00);
    // final expensesMonthlyValue = results.elementAt(3).getOrDefault(0.00);
    // final yearlyExpensesInRangeValue = results.elementAt(4).getOrDefault(0.00);
    // final invoicesInRangeValue = results.elementAt(5).getOrDefault(0.00);
    // final parcelsInRangeValue = results.elementAt(6).getOrDefault(0.00);

    // var date = actualDate.copyWith(day: 1);
    // var expensesSum = 0.00;
    // var incomesSum = 0.00;
    // var totalSum = expectedValueOfThisMonth +
    //     yearlyIncomesInRangeValue -
    //     parcelsInRangeValue -
    //     invoicesInRangeValue -
    //     yearlyExpensesInRangeValue;

    // date = date.add(months: 1);

    // while (!date.isMonthAfter(requestedDate)) {
    //   expensesSum += expensesMonthlyValue;
    //   incomesSum += incomesMonthlyValue;

    //   date = date.add(months: 1);
    // }

    // totalSum = totalSum + incomesSum - expensesSum;

    return Success(20.00);
  }

  @override
  Future<Result<double, Fail>> finalBalanceOf({
    required int month,
    required int year,
    Account? account,
  }) async {
    throw UnimplementedError();
    // return balanceRepository.getFinalBalanceOf(month: month, year: year);
  }
}
