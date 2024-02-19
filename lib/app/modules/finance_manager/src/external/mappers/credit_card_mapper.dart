import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/credit_card_table.dart';

abstract final class CreditCardMapper {
  static Map<String, dynamic> toMap(CreditCard card, {bool withId = true}) {
    return <String, dynamic>{
      if (withId) CreditCardTable.id: card.id,
      CreditCardTable.name: card.name,
      CreditCardTable.annuity: card.annuity,
      CreditCardTable.color: card.color,
      CreditCardTable.invoiceCloseDate: card.cardInvoiceClosingDate.toString(),
      CreditCardTable.invoiceOverdueDate: card.cardInvoiceDueDate.toString(),
    };
  }

  static CreditCard fromMap(Map<String, dynamic> map) {
    return CreditCard(
      id: map[CreditCardTable.id] as int,
      name: map[CreditCardTable.name] as String,
      annuity: map[CreditCardTable.annuity] as double,
      color: map[CreditCardTable.color] as String,
      cardInvoiceClosingDate: Date.parse(map[CreditCardTable.invoiceCloseDate]),
      cardInvoiceDueDate: Date.parse(map[CreditCardTable.invoiceOverdueDate]),
    );
  }
}
