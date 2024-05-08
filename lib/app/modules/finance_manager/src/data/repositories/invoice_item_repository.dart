import 'package:result_dart/result_dart.dart';

import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../errors/errors.dart';

abstract interface class InvoiceItemRepository {
  AsyncResult<Unit, Fail> addItemToInvoice({
    required Invoice invoice,
    required InvoiceItem item,
  });
  AsyncResult<Unit, Fail> updateItem({
    required InvoiceItem item,
    required Invoice invoice,
  });
  AsyncResult<Unit, Fail> removeItemFromInvoice({
    required Invoice invoice,
    required InvoiceItem item,
  });
  AsyncResult<Unit, Fail> removeItensFromInvoice({
    required Invoice invoice,
    required List<InvoiceItem> itens,
  });
}
