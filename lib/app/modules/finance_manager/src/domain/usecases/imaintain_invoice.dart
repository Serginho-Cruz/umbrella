import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

abstract class IMaintainInvoice {
  Future<Result<void, Fail>> generateInvoices();
  Future<Result<void, Fail>> addItemToInvoice({
    required InvoiceItem item,
    required Invoice invoice,
  });
  Future<Result<List<Invoice>, Fail>> getAll();
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice);
}
