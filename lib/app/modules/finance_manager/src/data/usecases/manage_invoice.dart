import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/invoice_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../repositories/balance_repository.dart';
import '../repositories/invoice_repository.dart';

class ManageInvoiceImpl implements ManageInvoice {
  final InvoiceRepository _repository;
  final BalanceRepository _balanceRepository;

  ManageInvoiceImpl({
    required InvoiceRepository repository,
    required BalanceRepository balanceRepository,
  })  : _repository = repository,
        _balanceRepository = balanceRepository;

  @override
  AsyncResult<Invoice, Fail> getActualOfCard(CreditCard card) {
    return _repository.getActualOfCard(card);
  }

  @override
  AsyncResult<List<Invoice>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    return _repository.getAllOf(month: month, year: year, account: account);
  }

  @override
  AsyncResult<List<Invoice>, Fail> getAllOfCard(CreditCard card) {
    return _repository.getAllOfCard(card);
  }

  @override
  AsyncResult<Unit, Fail> remove({
    required Invoice invoice,
    required Paiyable paiyable,
  }) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> removeItem({
    required Invoice invoice,
    required InvoiceItem item,
  }) {
    // TODO: implement removeItem
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> reset(Invoice invoice) {
    // TODO: implement reset
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> switchAccount(
    Invoice invoice,
    Account destinyAccount,
  ) async {
    if (invoice.account.id == destinyAccount.id) return const Success(unit);

    if (invoice.dueDate.isOfActualMonth) {
      var results = await Future.wait([
        _balanceRepository.addToExpected(
          invoice.remainingValue,
          invoice.account,
        ),
        _balanceRepository.subtractFromExpected(
          invoice.remainingValue,
          destinyAccount,
        ),
      ]);

      for (var result in results) {
        if (result.isError()) return result;
      }
    }
    var updateResult =
        await _repository.update(invoice.copyWith(account: destinyAccount));

    return updateResult;
  }

  @override
  AsyncResult<Unit, Fail> update({
    required Invoice oldInvoice,
    required Invoice newInvoice,
  }) async {
    if (oldInvoice == newInvoice) return const Success(unit);

    if (newInvoice.dueDate.isBefore(newInvoice.closingDate)) {
      return Failure(InvoiceUpdateError(InvoiceMessages.datesError));
    }

    var updatedInvoice =
        newInvoice.copyWith(isClosed: newInvoice.dueDate.isAfter(Date.today()));

    var updateRes = await _repository.update(updatedInvoice);

    if (updateRes.isError()) return updateRes;

    if (newInvoice.dueDate.isOfActualMonth &&
        !oldInvoice.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.subtractFromExpected(
        newInvoice.remainingValue,
        newInvoice.account,
      );

      if (res.isError()) return res;
    } else if (!newInvoice.dueDate.isOfActualMonth &&
        oldInvoice.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.addToExpected(
        newInvoice.remainingValue,
        newInvoice.account,
      );

      if (res.isError()) return res;
    }

    return updateRes;
  }

  @override
  AsyncResult<Unit, Fail> updateValue(Invoice invoice, double newValue) async {
    if (invoice.totalValue == newValue) return const Success(unit);

    double difference = (newValue - invoice.totalValue).roundToDecimal();

    var updatedInvoice = invoice.copyWith(
      totalValue: newValue,
      remainingValue: (invoice.remainingValue + difference).roundToDecimal(),
      paidValue: invoice.paidValue > newValue ? newValue : invoice.paidValue,
      adjust: (invoice.adjust + difference).roundToDecimal(),
    );

    var updateRes = await _repository.update(updatedInvoice);

    if (updateRes.isError()) return updateRes;

    if (invoice.paidValue > newValue) {
      double paidDifference = (invoice.paidValue - newValue).roundToDecimal();

      var res = await _balanceRepository.addToActual(
        paidDifference,
        invoice.account,
      );

      if (res.isError()) return res;

      //TODO: Call Refund usecase
    }

    if (invoice.dueDate.isOfActualMonth) {
      var res = await _balanceRepository.subtractFromExpected(
        difference,
        invoice.account,
      );

      if (res.isError()) return res;
    }

    return updateRes;
  }
}
