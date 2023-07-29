import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/date_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/generic_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/income.dart';
import '../../domain/entities/income_parcel.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/imanage_income.dart';
import '../../errors/errors.dart';
import '../repositories/iincome_repository.dart';

class ManageIncome implements IManageIncome {
  final IIncomeRepository incomeRepository;
  final IIncomeParcelRepository incomeParcelRepository;
  final IBalanceRepository balanceRepository;
  final ITransactionRepository transactionRepository;

  ManageIncome({
    required this.incomeRepository,
    required this.incomeParcelRepository,
    required this.balanceRepository,
    required this.transactionRepository,
  });

  @override
  Future<Result<void, Fail>> register(Income income) async {
    final invalidValue = _checkValues(income);

    if (invalidValue != null) {
      return Failure(invalidValue);
    }

    final incomeCreationResult = await incomeRepository.create(income);

    if (incomeCreationResult.isError()) {
      return incomeCreationResult;
    }

    return incomeParcelRepository.create(IncomeParcel.withoutId(
      income: income,
      paidValue: 0,
      remainingValue: income.value,
      dueDate: income.dueDate,
      paymentDate: null,
      totalValue: income.value,
    ));
  }

  @override
  Future<Result<void, Fail>> updateIncome(Income newIncome) async {
    final invalidValue = _checkValues(newIncome);

    if (invalidValue != null) return Failure(invalidValue);

    return incomeRepository.update(newIncome);
  }

  @override
  Future<Result<void, Fail>> updateParcel({
    required IncomeParcel oldParcel,
    required IncomeParcel newParcel,
  }) async {
    if (newParcel.totalValue <= 0) {
      return Failure(InvalidValue(GenericMessages.invalidNumber));
    }

    if (newParcel.totalValue > oldParcel.totalValue) {
      final incrementBalanceResult =
          await balanceRepository.sumToExpectedBalance(
              _calcDifference(newParcel.totalValue, oldParcel.totalValue));

      if (incrementBalanceResult.isError()) return incrementBalanceResult;
    } else if (newParcel.totalValue < oldParcel.totalValue) {
      final decrementBalanceResult =
          await balanceRepository.decrementFromExpectedBalance(
              _calcDifference(newParcel.totalValue, oldParcel.totalValue));

      if (decrementBalanceResult.isError()) return decrementBalanceResult;

      if (oldParcel.paidValue > newParcel.totalValue) {
        final difference =
            _calcDifference(newParcel.totalValue, oldParcel.paidValue);

        final decrementActualBalance =
            await balanceRepository.decrementFromActualBalance(difference);

        if (decrementActualBalance.isError()) return decrementActualBalance;

        final createAdjustTransaction =
            await transactionRepository.register(Transaction.withoutId(
          value: difference * -1,
          paymentDate: DateTime.now(),
          paiyable: newParcel,
          paymentMethod: PaymentMethod(
            id: 1,
            name: 'Atualização Receita ${newParcel.income.name}',
            isCredit: false,
            icon: '',
          ),
          isAdjust: true,
        ));

        if (createAdjustTransaction.isError()) return createAdjustTransaction;
      }
    }

    return incomeParcelRepository.update(newParcel);
  }

  @override
  Future<Result<List<IncomeParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  }) async {
    if (month < 1 || month > 12) {
      return Failure(DateError(DateErrorMessages.invalidMonth));
    }

    if (year < 2000) return Failure(DateError(DateErrorMessages.invalidYear));

    return incomeParcelRepository.getAllOf(month: month, year: year);
  }

  @override
  Future<Result<void, Fail>> deleteIncome(Income income) =>
      incomeRepository.delete(income);

  @override
  Future<Result<void, Fail>> deleteParcel(IncomeParcel parcel) async {
    final deleteParcel = await incomeParcelRepository.delete(parcel);

    if (deleteParcel.isError()) return deleteParcel;

    final decrementBalance =
        await balanceRepository.decrementFromExpectedBalance(parcel.totalValue);

    if (decrementBalance.isError()) return decrementBalance;

    if (parcel.paidValue > 0.0) {
      return balanceRepository.decrementFromActualBalance(parcel.paidValue);
    }

    return decrementBalance;
  }

  ///Check if name and value of an income are valid.
  ///
  ///Returns an InvalidValue if some value of income is invalid, null otherwise.
  InvalidValue? _checkValues(Income income) {
    if (income.value <= 0) {
      return InvalidValue(GenericMessages.invalidNumber);
    }
    if (income.name.isEmpty) {
      return InvalidValue(GenericMessages.emptyString);
    }
    if (income.name.length > 30) {
      return InvalidValue(GenericMessages.overLimitString);
    }

    return null;
  }

  double _calcDifference(double value1, double value2) =>
      (value1 - value2).abs().roundToDecimal();
}
