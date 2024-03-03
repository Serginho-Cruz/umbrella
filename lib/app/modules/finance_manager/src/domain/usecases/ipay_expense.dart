import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';

abstract class IPayExpense {
  Future<Result<void, Fail>> withoutCredit({
    required Expense expense,
    required double value,
    required PaymentMethod paymentMethod,
  });
  Future<Result<void, Fail>> withCredit({
    required Expense expense,
    required double value,
    required CreditCard card,
  });
  Installment turnIntoInstallment({
    required Expense expense,
    required int parcelsNumber,
    required CreditCard card,
    double parcelsValue,
  });
}
