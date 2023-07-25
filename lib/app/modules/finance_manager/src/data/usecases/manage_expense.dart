import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/date_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/generic_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/expense_parcel.dart';

import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

import '../../domain/usecases/imanage_expense.dart';
import '../repositories/iexpense_repository.dart';

class ManageExpense implements IManageExpense {
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;
  final IBalanceRepository balanceRepository;

  ManageExpense({
    required this.expenseRepository,
    required this.expenseParcelRepository,
    required this.balanceRepository,
  });

  @override
  Future<Result<void, Fail>> register(Expense expense) async {
    if (expense.value <= 0) {
      return Failure(InvalidValue(GenericMessages.invalidNumber));
    }
    if (expense.name.isEmpty) {
      return Failure(InvalidValue(GenericMessages.emptyString));
    }
    if (expense.name.length > 30) {
      return Failure(InvalidValue(GenericMessages.overLimitString));
    }

    final result = await expenseRepository.create(expense);

    if (result.isError()) {
      return result;
    }

    //Usar uma trigger para atualizar o saldo previsto
    return await expenseParcelRepository.create(
      ExpenseParcel.withoutId(
        expense: expense.copyWith(id: result.getOrDefault(0)),
        dueDate: expense.frequency == Frequency.daily
            ? DateTime.now()
            : expense.dueDate,
        paidValue: 0,
        remainingValue: expense.value,
        paymentDate: null,
        totalValue: expense.value,
      ),
    );
  }

  @override
  Future<Result<void, Fail>> updateExpense(Expense expense) async {
    if (expense.value <= 0) {
      return Failure(InvalidValue(GenericMessages.invalidNumber));
    }
    if (expense.name.isEmpty) {
      return Failure(InvalidValue(GenericMessages.emptyString));
    }
    if (expense.name.length > 30) {
      return Failure(InvalidValue(GenericMessages.overLimitString));
    }

    return await expenseRepository.update(expense);
  }

  @override
  Future<Result<void, Fail>> updateParcel({
    required ExpenseParcel oldParcel,
    required ExpenseParcel newParcel,
  }) async {
    if (newParcel.totalValue <= 0) {
      return Failure(InvalidValue(GenericMessages.invalidNumber));
    }

    final result = await expenseParcelRepository.update(newParcel);

    if (result.isError()) {
      return result;
    }

    if (newParcel.totalValue > oldParcel.totalValue) {
      return await balanceRepository.decrementFromExpectedBalance(
        newParcel.totalValue - oldParcel.totalValue,
      );
    }

    if (newParcel.totalValue < oldParcel.totalValue) {
      final updateExpectedBalance =
          await balanceRepository.sumToExpectedBalance(
              (oldParcel.totalValue - newParcel.totalValue).roundToDecimal());

      if (updateExpectedBalance.isError()) {
        return updateExpectedBalance;
      }

      if (oldParcel.paidValue > newParcel.totalValue) {
        return await balanceRepository.sumToActualBalance(
            (oldParcel.paidValue - newParcel.totalValue).roundToDecimal());
      }
    }

    return result;
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  }) async {
    if (month < 1 || month > 12) {
      return Failure(DateError(DateErrorMessages.invalidMonth));
    } else if (year < 2000) {
      return Failure(DateError(DateErrorMessages.invalidYear));
    }

    return expenseParcelRepository.getAllOf(month: month, year: year);
  }

  @override
  Future<Result<void, Fail>> deleteExpense(Expense expense) =>
      expenseRepository.delete(expense);

  @override
  Future<Result<void, Fail>> deleteParcel(ExpenseParcel parcel) async {
    //Usar uma trigger para deletar todas as transações
    //relacionadas a parcela
    final deleteParcel = await expenseParcelRepository.delete(parcel);

    if (deleteParcel.isError()) {
      return deleteParcel;
    }

    final updateExpectedBalance =
        await balanceRepository.sumToExpectedBalance(parcel.totalValue);

    if (updateExpectedBalance.isError()) {
      return updateExpectedBalance;
    }

    if (parcel.paidValue > 0) {
      return balanceRepository.sumToActualBalance(parcel.paidValue);
    }

    return updateExpectedBalance;
  }
}
