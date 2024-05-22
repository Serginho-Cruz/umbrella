import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/account.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  @override
  Future<Result<int, Fail>> generateOfCard(CreditCard card) {
    // TODO: implement generateOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, Fail>> update(Invoice newInvoice) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, Fail>> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  }) {
    // TODO: implement changeInvoicesFromCard
    throw UnimplementedError();
  }

  @override
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card) {
    // TODO: implement getActualOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
    required Account account,
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
  Future<Result<Invoice, Fail>> getFirstOpenInDateOfCard({
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
  AsyncResult<double, Fail> getInvoicesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  }) {
    // TODO: implement getInvoicesInRange
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> resetInvoice(Invoice invoice) {
    // TODO: implement resetInvoice
    throw UnimplementedError();
  }
}
