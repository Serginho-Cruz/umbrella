import 'package:result_dart/result_dart.dart';
import '../../domain/entities/date.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../errors/errors.dart';

abstract class IInvoiceRepository {
  Future<Result<int, Fail>> generateOfCard(CreditCard card);
  Future<Result<void, Fail>> update(Invoice newInvoice);
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<Invoice, Fail>> get(int id);
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card);
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card);
  Future<Result<Invoice, Fail>> getLastOfCard(CreditCard card);
  Future<Result<Invoice, Fail>> getFirstOpenInDateOfCard({
    required Date date,
    required CreditCard card,
  });
  Future<Result<double, Fail>> getSumOfInvoicesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<Result<void, Fail>> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  });
  Future<Result<void, Fail>> resetInvoice(Invoice invoice);
}
