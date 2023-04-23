import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

abstract class IMaintainInvoice {
  Result<void, Fail> generateInvoices();
  Result<void, Fail> addItemToInvoice({
    required InvoiceItem item,
    required Invoice invoice,
  });
  Result<List<Invoice>, Fail> getAll();
  Result<void, Fail> deleteInvoice(Invoice invoice);
}
