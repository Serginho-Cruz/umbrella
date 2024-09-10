import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

import '../../../domain/entities/account.dart';
import '../parse_objects.dart';
import 'account_mapper.dart';

sealed class CreditCardMapper {
  static ParseObject toParse(
    CreditCard card, {
    ParseUser? parseUser,
    bool noId = false,
  }) {
    var parseObject = CreditCardObject();

    var parseAccount = AccountMapper.toParse(card.accountToDiscountInvoice);

    if (!noId) parseObject.objectId = card.id;
    parseObject.set('name', card.name);
    parseObject.set('color', card.color);
    parseObject.set('invoiceCloseDay', card.cardInvoiceClosingDay);
    parseObject.set('invoiceOverdueDay', card.cardInvoiceDueDay);

    parseObject.set('account', parseAccount);
    if (parseUser != null) parseObject.set('user', parseUser);

    return parseObject;
  }

  static CreditCard fromParse(ParseObject object, {required Account account}) {
    return CreditCard(
      id: object.objectId!,
      name: object.get<String>('name')!,
      color: object.get<String>('color')!,
      cardInvoiceClosingDay: object.get<int>('invoiceCloseDay')!,
      cardInvoiceDueDay: object.get<int>('invoiceOverdueDay')!,
      accountToDiscountInvoice: account,
    );
  }
}
