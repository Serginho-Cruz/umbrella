import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../../domain/entities/account.dart';
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
  Future<Result<double, Fail>> initialOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    if (Date(day: 1, month: month, year: year).isMonthAfter(Date.today())) {
      return expectedOf(month: month - 1, year: year, account: account);
    }

    var initialBalance = await balanceRepository.getInitialBalanceOf(
      month: month,
      year: year,
      account: account,
    );

    return initialBalance;
  }

  @override
  Future<Result<double, Fail>> expectedOf({
    required int month,
    required int year,
    required Account account,
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
  Future<Result<double, Fail>> finalOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    throw UnimplementedError();
    // return balanceRepository.getFinalBalanceOf(month: month, year: year);
  }
}
