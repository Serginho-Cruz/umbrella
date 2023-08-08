import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../errors/errors.dart';

abstract class IInvoiceItemRepository {
  Future<Result<void, Fail>> addItemToInvoice({
    required Invoice invoice,
    required InvoiceItem item,
  });
  Future<Result<void, Fail>> addItemToInvoiceOfCard({
    required InvoiceItem item,
    required CreditCard card,
  });
  Future<Result<void, Fail>> addItensToInvoicesOfCard({
    required List<InvoiceItem> itens,
    required CreditCard card,
  });
  Future<Result<List<InvoiceItem>, Fail>> getAllOfInvoice(Invoice invoice);
  Future<Result<void, Fail>> removeItemFromInvoice({
    required Invoice invoice,
    required InvoiceItem item,
  });
  Future<Result<void, Fail>> removeItensFromInvoice({
    required Invoice invoice,
    required List<InvoiceItem> itens,
  });
}
