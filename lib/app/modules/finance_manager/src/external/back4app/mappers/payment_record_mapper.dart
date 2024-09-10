import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;

import '../../../domain/entities/account.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/paiyable.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/entities/payment_record.dart';
import '../parse_objects.dart';
import 'account_mapper.dart';
import 'expense_mapper.dart';
import 'income_mapper.dart';
import 'invoice_mapper.dart';
import 'payment_method_mapper.dart';

sealed class PaymentRecordMapper {
  static PaymentRecordObject toParse(
    PaymentRecord record, {
    bool noId = false,
  }) {
    var object = PaymentRecordObject();

    if (!noId) object.objectId = record.id;

    object.set('value', record.value);
    object.set('date', record.date.toDateTime());
    object.set(
        'paymentMethod', PaymentMethodMapper.toParse(record.paymentMethod));
    object.set('account', AccountMapper.toParse(record.usedAccount));

    switch (record.paiyable) {
      case Income():
        var obj = IncomeMapper.toParse(record.paiyable as Income);
        object.set('income', obj);
        break;
      case Expense():
        var obj = ExpenseMapper.toParse(record.paiyable as Expense);
        object.set('expense', obj);
        break;
      case Invoice():
        var obj = InvoiceMapper.toParse(record.paiyable as Invoice);
        object.set('invoice', obj);
        break;
    }

    return object;
  }

  static PaymentRecord fromParse(ParseObject object) {
    String id = object.objectId!;
    double value = (object.get('value') as num).toDouble();
    Date date = Date.fromDateTime(object.get('date') as DateTime);
    PaymentMethod paymentMethod =
        PaymentMethodMapper.fromParse(object.get('paymentMethod'));

    Account usedAccount = AccountMapper.fromParse(object.get('account'));

    Paiyable paiyable = switch (object) {
      _ when object.containsKey('expense') =>
        ExpenseMapper.fromParse(object.get('expense')),
      _ when object.containsKey('income') =>
        IncomeMapper.fromParse(object.get('income')),
      _ => InvoiceMapper.fromParse(object.get('invoice'), itens: []),
    };

    return PaymentRecord(
      id: id,
      usedAccount: usedAccount,
      paiyable: paiyable,
      paymentMethod: paymentMethod,
      value: value,
      date: date,
    );
  }
}
