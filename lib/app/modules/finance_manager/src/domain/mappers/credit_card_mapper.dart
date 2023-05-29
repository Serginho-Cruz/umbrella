import '../../external/schemas/credit_card_table.dart';
import '../../utils/datetime_extension.dart';
import '../entities/credit_card.dart';

abstract class CreditCardMapper {
  static Map<String, dynamic> toMap(CreditCard card) {
    return <String, dynamic>{
      CreditCardTable.id: card.id,
      CreditCardTable.name: card.name,
      CreditCardTable.annuity: card.annuity,
      CreditCardTable.color: card.color,
      CreditCardTable.invoiceClosingDate: card.cardInvoiceClosingDate.date,
      CreditCardTable.invoiceExpirationDate:
          card.cardInvoiceExpirationDate.date,
    };
  }

  static CreditCard fromMap(Map<String, dynamic> map) {
    return CreditCard(
      id: map[CreditCardTable.id] as int,
      name: map[CreditCardTable.name] as String,
      annuity: map[CreditCardTable.annuity] as double,
      color: map[CreditCardTable.color] as String,
      cardInvoiceClosingDate:
          DateTime.parse(map[CreditCardTable.invoiceClosingDate]),
      cardInvoiceExpirationDate: DateTime.parse(
        map[CreditCardTable.invoiceExpirationDate],
      ),
    );
  }
}
