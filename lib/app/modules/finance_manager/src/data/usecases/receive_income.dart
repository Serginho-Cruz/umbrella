import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_record_repository.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_record.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/payment_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/usecases/receive_income.dart';

class ReceiveIncomeImpl implements ReceiveIncome {
  final IncomeRepository incomeRepository;
  final PaymentRecordRepository paymentRecordRepository;
  final BalanceRepository balanceRepository;

  ReceiveIncomeImpl({
    required this.incomeRepository,
    required this.paymentRecordRepository,
    required this.balanceRepository,
  });

  @override
  AsyncResult<Unit, Fail> call(PaymentRecord<Income> payment) async {
    if (payment.paiyable.remainingValue < payment.value) {
      return const PaymentError(PaymentErrorMessages.valueGreaterThanRemaining)
          .toFailure();
    }

    const allowedMethods = [
      PaymentMethod.debit(),
      PaymentMethod.money(),
      PaymentMethod.pix(),
    ];

    if (!allowedMethods.contains(payment.paymentMethod)) {
      return const PaymentError(PaymentErrorMessages.invalidPaymentMethod)
          .toFailure();
    }

    var income = payment.paiyable;

    var updatedIncome = income.copyWith(
      remainingValue: (income.remainingValue - payment.value).roundToDecimal(),
      paidValue: (income.paidValue + payment.value).roundToDecimal(),
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

    var registerRes = await paymentRecordRepository.register(
      payment,
      payment.usedAccount,
    );

    if (registerRes.isError()) return registerRes.pure(unit);

    return const Success(unit);
  }
}
