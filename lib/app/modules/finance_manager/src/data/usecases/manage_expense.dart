import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/date_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/generic_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/expense_parcel.dart';

import '../../domain/entities/frequency.dart';
import '../../domain/entities/transaction.dart';
import '../../errors/errors.dart';

import '../../domain/usecases/imanage_expense.dart';
import '../repositories/iexpense_repository.dart';

class ManageExpense implements IManageExpense {
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;
  final IBalanceRepository balanceRepository;
  final ITransactionRepository transactionRepository;
  final IPaymentMethodRepository paymentMethodRepository;

  ManageExpense({
    required this.expenseRepository,
    required this.expenseParcelRepository,
    required this.balanceRepository,
    required this.transactionRepository,
    required this.paymentMethodRepository,
  });

  @override
  Future<Result<void, Fail>> register(Expense expense) async {
    final invalidValue = _checkValues(expense);
    if (invalidValue != null) return Failure(invalidValue);

    final result = await expenseRepository.create(expense);

    if (result.isError()) {
      return result;
    }

    //Usar uma trigger para atualizar o saldo previsto
    return expenseParcelRepository.create(
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
    final invalidValue = _checkValues(expense);

    return invalidValue != null
        ? Failure(invalidValue)
        : await expenseRepository.update(expense);
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

    if (result.isError()) return result;

    final totalValuesDifference =
        _calcDifference(oldParcel.totalValue, newParcel.totalValue);

    if (newParcel.totalValue > oldParcel.totalValue) {
      return balanceRepository
          .decrementFromExpectedBalance(totalValuesDifference);
    }
    if (newParcel.totalValue < oldParcel.totalValue) {
      final updateExpectedBalance =
          await balanceRepository.sumToExpectedBalance(totalValuesDifference);

      if (updateExpectedBalance.isError()) return updateExpectedBalance;

      if (oldParcel.paidValue > newParcel.totalValue) {
        final valuePaidWithCreditResult =
            await paymentMethodRepository.getValuePaidWithCredit(newParcel);

        if (valuePaidWithCreditResult.isError()) {
          return valuePaidWithCreditResult;
        }

        final valuePaidWithCredit = valuePaidWithCreditResult.getOrDefault(0.0);

        if (valuePaidWithCredit > newParcel.totalValue) {
          return Failure(
            CreditError(GenericMessages.creditErrorUpdatingParcel),
          );
        }
        _registerAdjustTransaction(
          value: totalValuesDifference,
          paiyable: newParcel,
        );

        final difference =
            _calcDifference(oldParcel.paidValue, newParcel.totalValue);

        final removeValueFromPayMethods =
            await paymentMethodRepository.removeValueFromNoCreditMethods(
          parcel: newParcel,
          value: totalValuesDifference,
        );

        if (removeValueFromPayMethods.isError()) {
          return removeValueFromPayMethods;
        }

        return balanceRepository.sumToActualBalance(difference);
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
    //Usar uma trigger para deletar todas as transações e registros
    //de métodos de pagamento relacionadas a parcela
    final deleteParcel = await expenseParcelRepository.delete(parcel);

    if (deleteParcel.isError()) return deleteParcel;

    final updateExpectedBalance =
        await balanceRepository.sumToExpectedBalance(parcel.totalValue);

    if (updateExpectedBalance.isError()) return updateExpectedBalance;

    if (parcel.paidValue > 0) {
      return balanceRepository.sumToActualBalance(parcel.paidValue);
    }

    return updateExpectedBalance;
  }

  InvalidValue? _checkValues(Expense expense) {
    if (expense.value <= 0) {
      return InvalidValue(GenericMessages.invalidNumber);
    }
    if (expense.name.isEmpty) {
      return InvalidValue(GenericMessages.emptyString);
    }
    if (expense.name.length > 30) {
      return InvalidValue(GenericMessages.overLimitString);
    }

    return null;
  }

  double _calcDifference(double value1, double value2) =>
      (value1 - value2).abs().roundToDecimal();

  Future<void> _registerAdjustTransaction({
    required double value,
    required ExpenseParcel paiyable,
  }) async {
    await transactionRepository.register(Transaction.withoutId(
      isAdjust: true,
      value: value * -1,
      paymentDate: DateTime.now(),
      paiyable: paiyable,
      paymentMethod: const PaymentMethod(
        icon: '',
        id: 1,
        isCredit: false,
        name: '',
      ),
    ));
  }
}
