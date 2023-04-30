import '../entities/credit_card.dart';
import '../../utils/datetime_extension.dart';

abstract class CreditCardMapper {
  static Map<String, dynamic> toMap(CreditCard card) {
    return <String, dynamic>{
      'id': card.id,
      'name': card.name,
      'annuity': card.annuity,
      'color': card.color,
      'cardInvoiceClosingDate': card.cardInvoiceClosingDate.date,
      'cardInvoiceExpirationDate': card.cardInvoiceExpirationDate.date,
    };
  }

  static CreditCard fromMap(Map<String, dynamic> map) {
    return CreditCard(
      id: map['id'] as int,
      name: map['name'] as String,
      annuity: map['annuity'] as double,
      color: map['color'] as String,
      cardInvoiceClosingDate: DateTime.parse(map['cardInvoiceClosingDate']),
      cardInvoiceExpirationDate: DateTime.parse(
        map['cardInvoiceExpirationDate'],
      ),
    );
  }
}
