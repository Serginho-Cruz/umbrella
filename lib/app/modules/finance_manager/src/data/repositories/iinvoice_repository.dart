import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../errors/errors.dart';

abstract class IInvoiceRepository {
  Future<Result<void, Fail>> generateAll();
  Future<Result<void, Fail>> generateOfCard(CreditCard card);
  Future<Result<void, Fail>> addItemToInvoice({
    required InvoiceItem item,
    required CreditCard card,
  });
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> getSumOfInvoicesInRange({
    required DateTime inferiorLimit,
    required DateTime upperLimit,
  });
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice);
}
