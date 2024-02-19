import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
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
  Future<Result<void, Fail>> turnIntoInstallment({
    required Invoice invoice,
    required double parcelsValue,
    required int parcelsNumber,
    required Date dueDate,
  });
}
