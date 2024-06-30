import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/manage_credit_card.dart';
import '../../domain/usecases/manage_invoice.dart';
import '../../errors/errors.dart';
import '../repositories/credit_card_repository.dart';
import '../repositories/invoice_repository.dart';

class ManageCreditCardImpl implements ManageCreditCard {
  final CreditCardRepository cardRepository;
  final ManageInvoice manageInvoice;
  final InvoiceRepository invoiceRepository;

  ManageCreditCardImpl({
    required this.manageInvoice,
    required this.cardRepository,
    required this.invoiceRepository,
  });

  @override
  AsyncResult<int, Fail> register(CreditCard card, User user) async {
    final cardCreateResult = await cardRepository.create(card, user);

    if (cardCreateResult.isError()) {
      return cardCreateResult;
    }

    return invoiceRepository.generateOfCard(card);
  }

  @override
  AsyncResult<Unit, Fail> update(
    CreditCard oldCard,
    CreditCard newCard,
  ) async {
    var cardUpdate = await cardRepository.update(newCard);

    if (cardUpdate.isError()) return cardUpdate;

    var invoicesFetch = await invoiceRepository.getAllOfCard(oldCard);

    if (invoicesFetch.isError()) return invoicesFetch.pure(unit);

    var invoices = invoicesFetch.getOrDefault([]);

    for (var invoice in invoices) {
      if (!invoice.isClosed) {
        int monthsToAdd = 0;

        if (newCard.cardInvoiceClosingDay > newCard.cardInvoiceDueDay) {
          monthsToAdd++;
        }

        manageInvoice.update(
          oldInvoice: invoice,
          newInvoice: invoice.copyWith(
            closingDate: invoice.closingDate.copyWith(
              day: newCard.cardInvoiceClosingDay,
            ),
            dueDate: invoice.dueDate.copyWith(
              day: newCard.cardInvoiceDueDay,
              month: invoice.dueDate.month + monthsToAdd,
            ),
          ),
        );
      }
    }

    return cardUpdate;
  }

  @override
  AsyncResult<List<CreditCard>, Fail> getAll(User user) async {
    var cards = await cardRepository.getAll(user);

    return cards;
  }

  @override
  AsyncResult<Unit, Fail> syncCard({
    required CreditCard cardToSync,
    required CreditCard cardToDelete,
  }) async {
    final changeCardFromInvoices =
        await invoiceRepository.changeInvoicesFromCard(
      originCard: cardToSync,
      destinyCard: cardToDelete,
    );

    if (changeCardFromInvoices.isError()) return changeCardFromInvoices;

    return cardRepository.delete(cardToDelete);
  }

  @override
  AsyncResult<Unit, Fail> cancel(CreditCard card) =>
      cardRepository.delete(card);

  @override
  AsyncResult<Unit, Fail> switchAccount(
    CreditCard card,
    Account newAccount,
  ) async {
    var updatedCard = card.copyWith(accountToDiscountInvoice: newAccount);

    var cardUpdateRes = await cardRepository.update(updatedCard);

    if (cardUpdateRes.isError()) return cardUpdateRes;

    var invoicesResult = await invoiceRepository.getAllOfCard(updatedCard);

    if (invoicesResult.isError()) return invoicesResult.pure(unit);

    for (var invoice in invoicesResult.getOrDefault([])) {
      if (!invoice.isClosed) {
        var switchRes = await manageInvoice.switchAccount(invoice, newAccount);

        if (switchRes.isError()) return switchRes;
      }
    }

    return cardUpdateRes;
  }
}
