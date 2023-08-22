import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../errors/errors.dart';

abstract class IInvoiceRepository {
  Future<Result<void, Fail>> generateOfCard(CreditCard card);
  Future<Result<void, Fail>> update(Invoice newInvoice);
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card);
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card);
  Future<Result<double, Fail>> getSumOfInvoicesInRange({
    required DateTime inferiorLimit,
    required DateTime upperLimit,
  });
  Future<Result<void, Fail>> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  });
  Future<Result<void, Fail>> resetInvoice(Invoice invoice);
}
