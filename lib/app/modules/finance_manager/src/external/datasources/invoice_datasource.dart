import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/invoice_datasource.dart';

class TemporaryInvoiceDatasource implements InvoiceDatasource {
  //Card's id and its invoices
  final Map<int, List<Invoice>> _invoices = {
    1: [
      Invoice(
        id: 1,
        totalValue: 0.00,
        paidValue: 0.00,
        remainingValue: 0.00,
        itens: const [],
        closingDate: Date(day: 9, month: 6, year: 2024),
        dueDate: Date(day: 18, month: 6, year: 2024),
        isClosed: false,
        accountToDiscount: const Account(
            id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
        card: const CreditCard(
          id: 1,
          name: 'Marisa',
          annuity: 0.00,
          color: '45ACFF',
          cardInvoiceClosingDay: 9,
          cardInvoiceDueDay: 18,
          accountToDiscountInvoice:
              Account(id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
        ),
      )
    ],
    2: [
      Invoice(
        id: 2,
        totalValue: 0.00,
        paidValue: 0.00,
        remainingValue: 0.00,
        itens: const [],
        closingDate: Date(day: 27, month: 6, year: 2024),
        dueDate: Date(day: 7, month: 7, year: 2024),
        isClosed: false,
        accountToDiscount: const Account(
            id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
        card: const CreditCard(
          id: 2,
          name: 'Banco do Brasil',
          annuity: 0.00,
          color: '12601A',
          cardInvoiceClosingDay: 27,
          cardInvoiceDueDay: 7,
          accountToDiscountInvoice:
              Account(id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
        ),
      )
    ],
    3: [
      Invoice(
        id: 3,
        totalValue: 0.00,
        paidValue: 0.00,
        remainingValue: 0.00,
        itens: const [],
        closingDate: Date(day: 2, month: 6, year: 2024),
        dueDate: Date(day: 12, month: 6, year: 2024),
        isClosed: true,
        accountToDiscount:
            const Account(id: 49, actualBalance: 200.00, name: 'Conta Padrão'),
        card: const CreditCard(
          id: 3,
          name: 'Daju',
          annuity: 10.00,
          color: '45ACFF',
          cardInvoiceClosingDay: 2,
          cardInvoiceDueDay: 12,
          accountToDiscountInvoice:
              Account(id: 49, actualBalance: 200.00, name: 'Conta Padrão'),
        ),
      )
    ],
  };

  @override
  Future<void> changeInvoicesFromCard({
    required CreditCard originCard,
    required CreditCard destinyCard,
  }) {
    // TODO: implement changeInvoicesFromCard
    throw UnimplementedError();
  }

  @override
  Future<int> generateOfCard(CreditCard card) {
    List<int> allIds = [];

    for (var invoices in _invoices.values) {
      for (var invoice in invoices) {
        allIds.add(invoice.id);
      }
    }

    allIds.sort();
    int newId = allIds.last + 1;

    Date today = Date.today();
    Date closeDate, dueDate;

    int closeDay = card.cardInvoiceClosingDay;
    int closeMonth = today.month;
    int closeYear = today.year;
    int dueDay = card.cardInvoiceDueDay;
    int dueMonth = today.month;
    int dueYear = today.year;

    if (today.day > closeDay) {
      closeMonth++;
      dueMonth++;
    }

    if (closeDay > dueDay) {
      dueMonth++;
    }

    closeDate = Date(day: closeDay, month: closeMonth, year: closeYear);
    dueDate = Date(day: dueDay, month: dueMonth, year: dueYear);

    var invoice = Invoice(
      id: newId,
      card: card,
      itens: const [],
      totalValue: 0.00,
      paidValue: 0.00,
      remainingValue: 0.00,
      isClosed: false,
      closingDate: closeDate,
      dueDate: dueDate,
      accountToDiscount: card.accountToDiscountInvoice,
    );

    _invoices.update(card.id, (value) => value..add(invoice),
        ifAbsent: () => [invoice]);

    return Future.delayed(const Duration(seconds: 1), () => newId);
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
  Future<Invoice> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Invoice>> getInRange({
    required Date inferiorLimit,
    required Date upperLimit,
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

  @override
  Future<void> update(Invoice invoice) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
