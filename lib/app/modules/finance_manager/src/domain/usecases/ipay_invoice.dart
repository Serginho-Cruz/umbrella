import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';
import '../entities/invoice.dart';
import '../entities/payment_method.dart';

abstract class IPayInvoice {
  Future<Result<void, Fail>> withoutCredit({
    required Invoice invoice,
    required double value,
    required PaymentMethod paymentMethod,
  });
  Future<Result<void, Fail>> withCredit({
    required Invoice invoice,
    required double value,
    required CreditCard card,
    required PaymentMethod paymentMethod,
  });
  Future<Result<Installment, Fail>> turnIntoInstallment({
    required Invoice invoice,
    required double parcelsValue,
    required int parcelsNumber,
    required DateTime dueDate,
  });
}
