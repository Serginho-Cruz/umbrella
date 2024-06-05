import 'package:result_dart/result_dart.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../errors/errors.dart';

abstract interface class InvoiceRepository {
  AsyncResult<int, Fail> generateOfCard(CreditCard card);
  AsyncResult<Unit, Fail> update(Invoice newInvoice);
  AsyncResult<List<Invoice>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Invoice, Fail> getById(int id);
  AsyncResult<List<Invoice>, Fail> getAllOfCard(CreditCard card);
  AsyncResult<Invoice, Fail> getActualOfCard(CreditCard card);
  AsyncResult<Invoice, Fail> getFirstOpenInDateOfCard({
    required Date date,
    required CreditCard card,
  });
  AsyncResult<List<Invoice>, Fail> getInvoicesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  //AsyncResult<List<Invoice>, Fail> getWhereHas(Paiyable paiyable);
  AsyncResult<Unit, Fail> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  });
  AsyncResult<Unit, Fail> resetInvoice(Invoice invoice);
}
