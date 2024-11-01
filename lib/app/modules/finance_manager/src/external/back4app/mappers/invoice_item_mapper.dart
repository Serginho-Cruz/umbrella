import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;

import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/invoice_item.dart';
import '../../../domain/entities/paiyable.dart';
import '../parse_objects.dart';
import 'expense_mapper.dart';
import 'invoice_mapper.dart';

sealed class InvoiceItemMapper {
  static InvoiceItemObject toParse(
    InvoiceItem item, {
    required Invoice invoice,
  }) {
    var object = InvoiceItemObject();

    object.set('value', item.value);
    object.set('date', item.paymentDate.toDateTime());

    if (item.paiyable is Expense) {
      object.set('expense', ExpenseMapper.toParse(item.paiyable as Expense));
    } else {
      object.set('invoice', InvoiceMapper.toParse(item.paiyable as Invoice));
    }

    object.set('belongingInvoice', invoice);

    return object;
  }

  static InvoiceItem fromParse(ParseObject object) {
    double value = object.get('value');
    Date paymentDate = Date.fromDateTime(object.get('date'));

    Paiyable paiyable;

    if (object.get('expense') != null) {
      paiyable = ExpenseMapper.fromParse(object.get('expense') as ParseObject);
    } else {
      paiyable = InvoiceMapper.fromParse(object.get('invoice'), itens: []);
    }

    return InvoiceItem(
      value: value,
      paymentDate: paymentDate,
      paiyable: paiyable,
    );
  }
}
