import '../../domain/entities/account.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/invoice.dart';

abstract interface class InvoiceDatasource {
  Future<int> generateOfCard(CreditCard card);
  Future<void> update(Invoice invoice);
  Future<List<Invoice>> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  Future<void> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  });
  Future<Invoice> getActualOfCard(CreditCard card);
  Future<List<Invoice>> getAllOfCard(CreditCard card);
  Future<Invoice> getOpenInDateOfCard({
    required Date date,
    required CreditCard card,
  });
  Future<Invoice> getById(int id);
  Future<List<Invoice>> getInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<void> reset(Invoice invoice);
}
