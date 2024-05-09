import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';
import '../entities/invoice.dart';
import '../entities/payment_method.dart';

abstract interface class PayInvoice {
  AsyncResult<Unit, Fail> withoutCredit({
    required Invoice invoice,
    required double value,
    required PaymentMethod paymentMethod,
  });
  AsyncResult<Unit, Fail> withCredit({
    required Invoice invoice,
    required double value,
    required CreditCard card,
  });
  Installment turnIntoInstallment({
    required Invoice invoice,
    required double parcelsValue,
    required int parcelsNumber,
    required Date dueDate,
  });
}
