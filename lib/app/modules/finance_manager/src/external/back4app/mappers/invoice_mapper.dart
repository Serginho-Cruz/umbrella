import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/credit_card.dart';
import '../../../domain/entities/date.dart';
import 'account_mapper.dart';
import 'credit_card_mapper.dart';

sealed class InvoiceMapper {
  static InvoiceObject toParse(Invoice invoice) {
    var object = InvoiceObject();

    object.set('totalValue', invoice.totalValue);
    object.set('paidValue', invoice.paidValue);
    object.set('remainingValue', invoice.remainingValue);
    object.set('interest', invoice.interest);
    object.set('adjust', invoice.adjust);
    object.set('iof', invoice.iof);
    object.set('closeDate', invoice.closingDate.toDateTime());
    object.set('overdueDate', invoice.dueDate.toDateTime());
    object.set('card', CreditCardMapper.toParse(invoice.card));
    object.set('account', AccountMapper.toParse(invoice.account));
    object.set('isClosed', invoice.isClosed);

    return object;
  }

  static Invoice fromParse(
    ParseObject object, {
    required List<InvoiceItem> itens,
  }) {
    double totalValue = object.get('totalValue');
    double paidValue = object.get('paidValue');
    double remainingValue = object.get('remainingValue');
    double iof = object.get('iof');
    double adjust = object.get('adjust');
    double interest = object.get('interest');

    bool isClosed = object.get('isClosed');
    Date closingDate = Date.fromDateTime(object.get('closeDate'));
    Date dueDate = Date.fromDateTime(object.get('overdueDate'));

    Account account = AccountMapper.fromParse(object.get('account'));

    CreditCard card = CreditCardMapper.fromParse(
      object.get('card'),
      account: account,
    );

    return Invoice(
      id: object.objectId!,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      dueDate: dueDate,
      account: account,
      isClosed: isClosed,
      closingDate: closingDate,
      card: card,
      iof: iof,
      adjust: adjust,
      interest: interest,
      itens: itens,
    );
  }
}
