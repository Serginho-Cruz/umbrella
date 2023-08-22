import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/expense_parcel.dart';
import '../entities/installment.dart';
import '../entities/payment_method.dart';

abstract class IPayExpense {
  Future<Result<void, Fail>> withoutCredit({
    required ExpenseParcel expense,
    required double value,
  });
  Future<Result<void, Fail>> withCredit({
    required ExpenseParcel expense,
    required double value,
    required CreditCard card,
  });
  Installment turnIntoInstallment({
    required ExpenseParcel parcel,
    required int parcelsNumber,
    required PaymentMethod paymentMethod,
    double parcelsValue,
  });
}
