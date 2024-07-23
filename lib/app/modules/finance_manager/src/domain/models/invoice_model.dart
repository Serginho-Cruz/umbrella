import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';

import '../entities/credit_card.dart';
import '../entities/date.dart';
import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

class InvoiceModel extends PaiyableModel<Invoice> {
  final Date closingDate;
  final bool isClosed;
  final CreditCard card;
  final List<InvoiceItem> itens;
  final double adjust;
  final double interest;

  InvoiceModel.fromInvoice(
    Invoice invoice, {
    required super.status,
  })  : closingDate = invoice.closingDate,
        isClosed = invoice.isClosed,
        card = invoice.card,
        itens = invoice.itens,
        adjust = invoice.adjust,
        interest = invoice.interest,
        super(
          id: invoice.id,
          totalValue: invoice.totalValue,
          paidValue: invoice.paidValue,
          remainingValue: invoice.remainingValue,
          overdueDate: invoice.dueDate,
          account: invoice.account,
          paymentDate: invoice.paymentDate,
        );

  @override
  Invoice toEntity() {
    return Invoice(
      id: id,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      closingDate: closingDate,
      dueDate: overdueDate,
      isClosed: isClosed,
      card: card,
      itens: itens,
      account: account,
    );
  }
}
