import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

abstract class IMaintainInvoice {
  Future<Result<void, Fail>> generateInvoices();
  Future<Result<void, Fail>> addItemToInvoice({
    required InvoiceItem item,
    required CreditCard card,
  });
  Future<Result<List<Invoice>, Fail>> getAll(int month);
  Future<Result<List<Invoice>, Fail>> getByValue(int month);
  Future<Result<List<Invoice>, Fail>> getByExpirationDate(int month);
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice);
}
