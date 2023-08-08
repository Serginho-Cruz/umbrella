import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';

abstract class IManageInvoice {
  Future<Result<void, Fail>> update({
    required Invoice newInvoice,
    required Invoice oldInvoice,
  });
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card);
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card);
  Future<Result<void, Fail>> reset(Invoice invoice);
}
