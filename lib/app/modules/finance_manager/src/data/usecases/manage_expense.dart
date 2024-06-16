import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/installment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_invoice.dart';
import '../../domain/entities/account.dart';
import '../repositories/balance_repository.dart';
import '../repositories/payment_method_repository.dart';
import '../repositories/transaction_repository.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

import '../../domain/usecases/manage_expense.dart';
import '../repositories/expense_repository.dart';

class ManageExpenseImpl implements ManageExpense {
  final ExpenseRepository expenseRepository;
  final ManageInstallment manageInstallment;
  final InvoiceRepository invoiceRepository;
  final InstallmentRepository installmentRepository;
  final ManageInvoice manageInvoice;
  final BalanceRepository balanceRepository;
  final TransactionRepository transactionRepository;
  final PaymentMethodRepository paymentMethodRepository;

  ManageExpenseImpl({
    required this.expenseRepository,
    required this.installmentRepository,
    required this.manageInstallment,
    required this.invoiceRepository,
    required this.manageInvoice,
    required this.balanceRepository,
    required this.transactionRepository,
    required this.paymentMethodRepository,
  });

  @override
  Future<Result<int, Fail>> register(Expense expense, Account account) async {
    final result = await expenseRepository.create(expense, account);

    if (result.isError()) return result;

    if (expense.dueDate.isOfActualMonth) {
      var decrementResult = await balanceRepository.subtractFromExpected(
        expense.totalValue,
        account,
      );

      if (decrementResult.isError()) return decrementResult.pure(0);
    }

    return result;
  }

  @override
  Future<Result<Unit, Fail>> update({
    required Expense oldExpense,
    required Expense newExpense,
    required Account account,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Expense>, Fail>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    var expenses = <Expense>[];

    var requiredDate = Date(day: 1, month: month, year: year);

    if (requiredDate.isMonthAfter(Date.today())) {
      var monthlyExpenses =
          await expenseRepository.getByFrequency(Frequency.monthly, account);

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

    var requiredMonthExpenses = await expenseRepository.getAllOf(
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
  Future<Result<Unit, Fail>> delete(Expense expense, Account account) async {
    final deleteResult = await expenseRepository.delete(expense);

    if (deleteResult.isError()) return deleteResult;

    final updateExpectedBalance = await balanceRepository.addToExpected(
      expense.totalValue,
      account,
    );

    if (updateExpectedBalance.isError()) return updateExpectedBalance;

    if (expense.paidValue > 0.00) {
      return balanceRepository.addToActual(
        expense.paidValue,
        account,
      );
    }

    return updateExpectedBalance;
  }
}
