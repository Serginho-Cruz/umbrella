import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_record.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/pay_expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/payment_method.dart';
import '../../errors/payment_error_messages.dart';
import '../repositories/balance_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/payment_record_repository.dart';

class PayExpenseImpl implements PayExpense {
  final ExpenseRepository expenseRepository;
  final PaymentRecordRepository paymentRecordRepository;
  final BalanceRepository balanceRepository;

  PayExpenseImpl({
    required this.expenseRepository,
    required this.paymentRecordRepository,
    required this.balanceRepository,
  });

  @override
  AsyncResult<Unit, Fail> withCredit(
    PaymentRecord<Expense> expense,
    CreditCard card,
  ) {
    // TODO: implement withCredit
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> withoutCredit(PaymentRecord<Expense> payment) async {
    if (payment.paiyable.remainingValue < payment.value) {
      return const PaymentError(PaymentErrorMessages.valueGreaterThanRemaining)
          .toFailure();
    }

    const allowedMethods = [
      PaymentMethod.boleto(),
      PaymentMethod.debit(),
      PaymentMethod.money(),
      PaymentMethod.pix(),
    ];

    if (!allowedMethods.contains(payment.paymentMethod)) {
      return const PaymentError(PaymentErrorMessages.invalidPaymentMethod)
          .toFailure<Unit>();
    }

    var expense = payment.paiyable;

    var updatedExpense = expense.copyWith(
      remainingValue: (expense.remainingValue - payment.value).roundToDecimal(),
      paidValue: (expense.paidValue + payment.value).roundToDecimal(),
    );

    var updateExpenseRes = await expenseRepository.update(updatedExpense);

    if (updateExpenseRes.isError()) return updateExpenseRes;

    var updatesNeeded = [
      balanceRepository.subtractFromActual(
        payment.value,
        payment.usedAccount,
      ),
    ];

    if (payment.usedAccount.id != expense.account.id) {
      updatesNeeded.addAll([
        balanceRepository.addToExpected(payment.value, expense.account),
        balanceRepository.subtractFromExpected(
          payment.value,
          payment.usedAccount,
        ),
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
