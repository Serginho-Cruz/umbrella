import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';

abstract interface class PayExpense {
  AsyncResult<Unit, Fail> withoutCredit(Payment<Expense> expense);
  AsyncResult<Unit, Fail> withCredit(
    Payment<Expense> expense,
    CreditCard card,
  );
  Installment turnIntoInstallment({
    required Expense expense,
    required int parcelsNumber,
    required CreditCard card,
    double? parcelsValue,
  });
}
