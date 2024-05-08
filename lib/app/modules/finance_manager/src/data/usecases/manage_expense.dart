import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/installment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/finance_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_invoice.dart';
import '../repositories/balance_repository.dart';
import '../repositories/payment_method_repository.dart';
import '../repositories/transaction_repository.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/payment_method.dart';
import '../../utils/extensions.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/frequency.dart';
import '../../domain/entities/transaction.dart';
import '../../errors/errors.dart';

import '../../domain/usecases/imanage_expense.dart';
import '../repositories/expense_repository.dart';

class ManageExpense implements IManageExpense {
  final ExpenseRepository expenseRepository;
  final IManageInstallment manageInstallment;
  final InvoiceRepository invoiceRepository;
  final InstallmentRepository installmentRepository;
  final IManageInvoice manageInvoice;
  final BalanceRepository balanceRepository;
  final TransactionRepository transactionRepository;
  final PaymentMethodRepository paymentMethodRepository;

  ManageExpense({
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
  Future<Result<int, Fail>> register(Expense expense) async {
    final result = await expenseRepository.create(expense);

    if (result.isError()) return result;

    if (expense.dueDate.isOfActualMonth) {
      var decrementResult =
          await balanceRepository.decrementFromExpectedBalance(
        expense.totalValue,
        expense.account,
      );

      if (decrementResult.isError()) return decrementResult.pure(2);
    }

    return result;
  }

  @override
  Future<Result<void, Fail>> update({
    required Expense oldExpense,
    required Expense newExpense,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ExpenseModel>, Fail>> getAllOf({
    required int month,
    required int year,
  }) async {
    var expenses = <Expense>[];

    var requiredDate = Date(day: 1, month: month, year: year);

    if (requiredDate.isMonthAfter(Date.today())) {
      var monthlyExpenses =
          await expenseRepository.getByFrequency(Frequency.monthly);

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
    );

    if (requiredMonthExpenses.isError()) {
      return Failure(requiredMonthExpenses.exceptionOrNull()!);
    }

    expenses.addAll(requiredMonthExpenses.getOrDefault([]));

    return Success(List.generate(
        expenses.length,
        (i) => ExpenseModel.fromExpense(expenses[i],
            status: _determineExpenseStatus(expenses[i]))));
  }

  Status _determineExpenseStatus(Expense e) {
    if (e.dueDate.isBefore(Date.today()) && e.remainingValue == 0.00) {
      return Status.overdue;
    }
    if (e.remainingValue == 0.00) return Status.okay;

    return Status.inTime;
  }

  @override
  Future<Result<void, Fail>> delete(Expense expense) async {
    final deleteResult = await expenseRepository.delete(expense);

    if (deleteResult.isError()) return deleteResult;

    final updateExpectedBalance = await balanceRepository.sumToExpectedBalance(
      expense.totalValue,
      expense.account,
    );

    if (updateExpectedBalance.isError()) return updateExpectedBalance;

    if (expense.paidValue > 0.00) {
      return balanceRepository.sumToActualBalance(
        expense.paidValue,
        expense.account,
      );
    }

    return updateExpectedBalance;
  }

  double _calcDifference(double value1, double value2) =>
      (value1 - value2).abs().roundToDecimal();

  Future<void> _registerAdjustTransaction({
    required double value,
    required Expense paiyable,
  }) async {
    await transactionRepository.register(Transaction.withoutId(
      isAdjust: true,
      value: value * -1,
      paymentDate: Date.today(),
      paiyable: paiyable,
      paymentMethod: PaymentMethod.money(),
    ));
  }
}
