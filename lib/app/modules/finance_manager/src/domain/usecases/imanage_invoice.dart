import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';

abstract class IManageInvoice {
  Future<Result<void, Fail>> generateInvoices();
  Future<Result<Invoice, Fail>> update({
    required Invoice newInvoice,
    required Invoice oldInvoice,
  });
  Future<Result<Invoice, Fail>> getActualOf(CreditCard card);
  Future<Result<List<Invoice>, Fail>> getAllOf(DateTime month);
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card);
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice);
}
