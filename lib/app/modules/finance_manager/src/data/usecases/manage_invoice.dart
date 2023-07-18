import 'package:result_dart/result_dart.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/imanage_invoice.dart';
import '../../errors/errors.dart';

import '../repositories/iinvoice_repository.dart';

class ManageInvoice implements IManageInvoice {
  final IInvoiceRepository repository;

  ManageInvoice(this.repository);

  @override
  Future<Result<void, Fail>> deleteInvoice(Invoice invoice) {
    // TODO: implement deleteInvoice
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> generateInvoices() {
    // TODO: implement generateInvoices
    throw UnimplementedError();
  }

  @override
  Future<Result<Invoice, Fail>> getActualOf(CreditCard card) {
    // TODO: implement getActualOf
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOf(DateTime month) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card) {
    // TODO: implement getAllOfCard
    throw UnimplementedError();
  }

  @override
  Future<Result<Invoice, Fail>> update({
    required Invoice newInvoice,
    required Invoice oldInvoice,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
