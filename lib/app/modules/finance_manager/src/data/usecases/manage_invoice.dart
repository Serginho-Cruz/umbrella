import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class ManageInvoice implements IManageInvoice {
  @override
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card) {
    // TODO: implement getActualOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card) {
    // TODO: implement getAllOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> remove(
      {required Invoice invoice, required Paiyable paiyable}) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> removeItem(
      {required Invoice invoice, required InvoiceItem item}) {
    // TODO: implement removeItem
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> reset(Invoice invoice) {
    // TODO: implement reset
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(
      {required Invoice newInvoice, required Invoice oldInvoice}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
