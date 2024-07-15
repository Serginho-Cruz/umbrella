import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/account.dart';
import '../datasources/invoice_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceDatasource _invoiceDatasource;

  InvoiceRepositoryImpl(this._invoiceDatasource);

  @override
  AsyncResult<int, Fail> generateOfCard(CreditCard card) async {
    try {
      var id = await _invoiceDatasource.generateOfCard(card);
      return Success(id);
    } on Fail catch (fail) {
      return Failure(fail);
    } catch (e) {
      return GenericError().toFailure();
    }
  }

  @override
  AsyncResult<Unit, Fail> update(Invoice newInvoice) async {
    try {
      await _invoiceDatasource.update(newInvoice);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  }) {
    // TODO: implement changeInvoicesFromCard
    throw UnimplementedError();
  }

  @override
  AsyncResult<Invoice, Fail> getActualOfCard(CreditCard card) {
    // TODO: implement getActualOfCard
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Invoice>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var invoices = await _invoiceDatasource.getAllOf(
        month: month,
        year: year,
        account: account,
      );

      return Success(invoices);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Invoice>, Fail> getAllOfCard(CreditCard card) async {
    try {
      var invoices = await _invoiceDatasource.getAllOfCard(card);
      return Success(invoices);
    } on Fail catch (fail) {
      return Failure(fail);
    } catch (e) {
      return GenericError().toFailure();
    }
  }

  @override
  AsyncResult<Invoice, Fail> getFirstOpenInDateOfCard({
    required Date date,
    required CreditCard card,
  }) {
    // TODO: implement getFirstOpenInDateOfCard
    throw UnimplementedError();
  }

  @override
  AsyncResult<Invoice, Fail> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Invoice>, Fail> getInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Account account,
  }) async {
    try {
      var list = await _invoiceDatasource.getInRange(
        inferiorLimit: inferiorLimit,
        upperLimit: upperLimit,
        account: account,
      );

      return Success(list);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> reset(Invoice invoice) {
    // TODO: implement resetInvoice
    throw UnimplementedError();
  }
}
