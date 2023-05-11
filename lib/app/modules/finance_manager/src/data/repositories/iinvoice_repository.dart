import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../errors/errors.dart';

abstract class IInvoiceRepository {
  Future<Result<void, Fail>> addItemToInvoice({
    required InvoiceItem item,
    required CreditCard card,
  });
  Future<Result<List<Invoice>, Fail>> getAll();
  Future<Result<void, Fail>> generateAll();
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice);
}
