import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_record.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';

abstract interface class PayInvoice {
  AsyncResult<Unit, Fail> withoutCredit(PaymentRecord<Invoice> invoice);
  AsyncResult<Unit, Fail> withCredit(
    PaymentRecord<Invoice> invoice,
    CreditCard card,
  );
}
