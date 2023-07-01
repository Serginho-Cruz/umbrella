import 'credit_card_mapper.dart';
import '../../external/schemas/invoice_table.dart';
import '../../utils/extensions.dart';

import '../entities/invoice_item.dart';
import '../entities/invoice.dart';

abstract class InvoiceMapper {
  static Map<String, dynamic> toMap(Invoice invoice) => <String, dynamic>{
        InvoiceTable.id: invoice.id,
        InvoiceTable.value: invoice.value,
        InvoiceTable.expirationDate: invoice.expirationDate.date,
        InvoiceTable.closingDate: invoice.closingDate.date,
        InvoiceTable.isClosed: invoice.isClosed,
        InvoiceTable.cardId: invoice.card.id,
      };

  static Invoice fromMap({
    required Map<String, dynamic> map,
    required List<InvoiceItem> itens,
  }) =>
      Invoice(
        id: map[InvoiceTable.id] as int,
        value: map[InvoiceTable.value] as double,
        isClosed: map[InvoiceTable.isClosed] as bool,
        expirationDate:
            DateTime.parse(map[InvoiceTable.expirationDate] as String),
        closingDate: DateTime.parse(map[InvoiceTable.closingDate] as String),
        card: CreditCardMapper.fromMap(map),
        itens: itens,
      );
}
