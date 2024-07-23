import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/transaction_repository.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/payment_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/date.dart';
import '../../domain/usecases/receive_income.dart';

class ReceiveIncomeImpl implements ReceiveIncome {
  final IncomeRepository incomeRepository;
  final PaymentMethodRepository paymentMethodRepository;
  final TransactionRepository transactionRepository;
  final BalanceRepository balanceRepository;

  ReceiveIncomeImpl({
    required this.incomeRepository,
    required this.paymentMethodRepository,
    required this.transactionRepository,
    required this.balanceRepository,
  });

  @override
  AsyncResult<Unit, Fail> call(Payment<Income> payment) async {
    if (payment.paiyable.remainingValue < payment.value) {
      return PaymentError(PaymentErrorMessages.valueGreaterThanRemaining)
          .toFailure();
    }

    const allowedMethods = [
      PaymentMethod.debit(),
      PaymentMethod.money(),
      PaymentMethod.pix(),
    ];

    if (!allowedMethods.contains(payment.paymentMethod)) {
      return PaymentError(PaymentErrorMessages.invalidPaymentMethod)
          .toFailure();
    }

    var income = payment.paiyable;

    var updatedIncome = income.copyWith(
      remainingValue: (income.remainingValue - payment.value).roundToDecimal(),
      paidValue: (income.paidValue + payment.value).roundToDecimal(),
      paymentDate: Date.today(),
    );

    var updateIncomeRes = await incomeRepository.update(updatedIncome);

    if (updateIncomeRes.isError()) return updateIncomeRes;

    var updatesNeeded = [
      balanceRepository.addToActual(
        payment.value,
        payment.usedAccount,
      ),
    ];

    if (payment.usedAccount.id != income.account.id) {
      updatesNeeded.addAll([
        balanceRepository.subtractFromExpected(payment.value, income.account),
        balanceRepository.addToExpected(payment.value, payment.usedAccount),
      ]);
    }

    var balanceUpdates = await Future.wait(updatesNeeded);

    if (balanceUpdates.any((res) => res.isError())) {
      return balanceUpdates.firstWhere((res) => res.isError());
    }

    var transaction = Transaction(
      id: 0,
      value: payment.value,
      paymentDate: Date.today(),
      paiyable: updatedIncome,
      paymentMethod: payment.paymentMethod,
    );

    var transactionRes = await transactionRepository.register(
      transaction,
      payment.usedAccount,
    );

    if (transactionRes.isError()) return transactionRes.pure(unit);

    var addPaymentRegister = await paymentMethodRepository.registerPayment(
      paiyable: updatedIncome,
      value: payment.value,
      method: payment.paymentMethod,
    );

    if (addPaymentRegister.isError()) return addPaymentRegister;

    return const Success(unit);
  }
}
