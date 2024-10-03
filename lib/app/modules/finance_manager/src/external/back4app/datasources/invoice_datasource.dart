import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';

import '../../../infra/datasources/invoice_datasource.dart';
import '../functions.dart';
import '../mappers/credit_card_mapper.dart';
import '../mappers/invoice_mapper.dart';
import '../parse_objects.dart';

class Back4AppInvoiceDatasource implements InvoiceDatasource {
  @override
  Future<String> generateOfCard(CreditCard card) async {
    var object = InvoiceObject();

    var query = QueryBuilder(object);

    query.whereEqualTo('card', CreditCardMapper.toParse(card));
    query.orderByDescending('overdueDate');

    var response = await query.query();

    if (!isResponseSuccesful(response)) {
      throw extractFail(response);
    }

    Date close, overdue;

    if (response.results == null || response.results!.isEmpty) {
      close = Date.today().copyWith(day: card.cardInvoiceClosingDay);
      overdue = Date.today().copyWith(day: card.cardInvoiceDueDay);
    } else {
      ParseObject object = response.results!.first;
      Date closeDate = Date.fromDateTime(object.get('closeDate'));
      Date overdueDate = Date.fromDateTime(object.get('overdueDate'));

      (:close, :overdue) = _resolveNewDates(
        lastCloseDate: closeDate,
        lastOverdueDate: overdueDate,
        card: card,
      );
    }

    var invoice = Invoice(
      id: '',
      totalValue: 0.00,
      paidValue: 0.00,
      remainingValue: 0.00,
      dueDate: overdue,
      account: card.accountToDiscountInvoice,
      isClosed: Date.today().isAfter(close),
      closingDate: close,
      card: card,
      itens: const [],
    );

    var newInvoiceObject = InvoiceMapper.toParse(invoice);

    var createResponse = await newInvoiceObject.create();

    if (isResponseSuccesful(createResponse)) {
      return (createResponse.results!.first as ParseObject).objectId!;
    }

    throw extractFail(createResponse);
  }

  @override
  Future<void> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  }) {
    // TODO: implement changeInvoicesFromCard
    throw UnimplementedError();
  }

  @override
  Future<void> update(Invoice invoice) async {
    var object = InvoiceMapper.toParse(invoice);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }

  @override
  Future<Invoice> getActualOfCard(CreditCard card) {
    // TODO: implement getActualOfCard
    throw UnimplementedError();
  }

  @override
  Future<List<Invoice>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<List<Invoice>> getAllOfCard(CreditCard card) {
    // TODO: implement getAllOfCard
    throw UnimplementedError();
  }

  @override
  Future<Invoice> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Invoice>> getInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Account account,
  }) {
    // TODO: implement getInRange
    throw UnimplementedError();
  }

  @override
  Future<Invoice> getOpenInDateOfCard({
    required Date date,
    required CreditCard card,
  }) {
    // TODO: implement getOpenInDateOfCard
    throw UnimplementedError();
  }

  @override
  Future<void> reset(Invoice invoice) {
    // TODO: implement reset
    throw UnimplementedError();
  }

  int _resolveDay(Date date, int cardDay) {
    int totalDays = Date.totalDaysOnMonth(date.month, date.year);

    return cardDay > totalDays ? totalDays : cardDay;
  }

  ({Date close, Date overdue}) _resolveNewDates({
    required Date lastCloseDate,
    required Date lastOverdueDate,
    required CreditCard card,
  }) {
    Date secureCloseDate = lastCloseDate.copyWith(day: 15);
    Date secureOverdueDate = lastOverdueDate.copyWith(day: 15);

    int closeDay = _resolveDay(
      secureCloseDate.add(months: 1),
      card.cardInvoiceClosingDay,
    );

    int overdueDay = _resolveDay(
      secureOverdueDate.add(months: 1),
      card.cardInvoiceDueDay,
    );

    Date close = secureCloseDate.add(months: 1).copyWith(day: closeDay);
    Date overdue = secureOverdueDate.add(months: 1).copyWith(day: overdueDay);

    return (close: close, overdue: overdue);
  }
}
