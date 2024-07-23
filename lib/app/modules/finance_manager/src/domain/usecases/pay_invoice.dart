import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';
import '../entities/invoice.dart';

abstract interface class PayInvoice {
  AsyncResult<Unit, Fail> withoutCredit(Payment<Invoice> invoice);
  AsyncResult<Unit, Fail> withCredit(
    Payment<Invoice> invoice,
    CreditCard card,
  );
  Installment turnIntoInstallment({
    required Invoice invoice,
    required double parcelsValue,
    required int parcelsNumber,
    required Date dueDate,
  });
}
