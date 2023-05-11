import 'package:result_dart/result_dart.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../domain/usecases/imaintain_invoice.dart';
import '../../errors/errors.dart';

import '../repositories/iinvoice_repository.dart';

class MaintainInvoiceUC implements IMaintainInvoice {
  final IInvoiceRepository repository;

  MaintainInvoiceUC(this.repository);

  @override
  Future<Result<void, Fail>> addItemToInvoice({
    required InvoiceItem item,
    required CreditCard card,
  }) {
    return repository.addItemToInvoice(item: item, card: card);
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAll() {
    return repository.getAll();
  }

  @override
  Future<Result<void, Fail>> generateInvoices() {
    return repository.generateAll();
  }

  @override
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice) {
    return repository.deleteInvoice(invoice);
  }
}
