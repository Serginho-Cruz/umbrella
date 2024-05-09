import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';

abstract interface class PayExpense {
  AsyncResult<Unit, Fail> withoutCredit({
    required Expense expense,
    required double value,
    required PaymentMethod paymentMethod,
    required Account account,
  });
  AsyncResult<Unit, Fail> withCredit({
    required Expense expense,
    required double value,
    required CreditCard card,
  });
  Installment turnIntoInstallment({
    required Expense expense,
    required int parcelsNumber,
    required CreditCard card,
    double? parcelsValue,
  });
}
