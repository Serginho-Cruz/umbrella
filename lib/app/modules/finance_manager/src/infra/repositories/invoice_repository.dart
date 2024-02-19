import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class InvoiceRepository implements IInvoiceRepository {
  @override
  Future<Result<int, Fail>> generateOfCard(CreditCard card) {
    // TODO: implement generateOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(Invoice newInvoice) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  }) {
    // TODO: implement changeInvoicesFromCard
    throw UnimplementedError();
  }

  @override
  Future<Result<Invoice, Fail>> get(int id) {
    // TODO: implement get
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
  Future<Result<Invoice, Fail>> getLastOfCard(CreditCard card) {
    // TODO: implement getLastOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<double, Fail>> getSumOfInvoicesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  }) {
    // TODO: implement getSumOfInvoicesInRange
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> resetInvoice(Invoice invoice) {
    // TODO: implement resetInvoice
    throw UnimplementedError();
  }
}
