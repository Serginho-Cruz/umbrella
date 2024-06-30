import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';

abstract interface class ManageInvoice {
  AsyncResult<Unit, Fail> update({
    required Invoice oldInvoice,
    required Invoice newInvoice,
  });
  AsyncResult<Unit, Fail> updateValue(Invoice invoice, double newValue);
  AsyncResult<Unit, Fail> switchAccount(
    Invoice invoice,
    Account destinyAccount,
  );
  AsyncResult<List<Invoice>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Invoice, Fail> getActualOfCard(CreditCard card);
  AsyncResult<List<Invoice>, Fail> getAllOfCard(CreditCard card);
  AsyncResult<Unit, Fail> removeItem({
    required Invoice invoice,
    required InvoiceItem item,
  });
  AsyncResult<Unit, Fail> remove({
    required Invoice invoice,
    required Paiyable paiyable,
  });
  AsyncResult<Unit, Fail> reset(Invoice invoice);
}
