import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/manage_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/credit_card_repository.dart';
import '../repositories/invoice_repository.dart';

class ManageCreditCardImpl implements ManageCreditCard {
  final CreditCardRepository cardRepository;
  final InvoiceRepository invoiceRepository;

  ManageCreditCardImpl({
    required this.cardRepository,
    required this.invoiceRepository,
  });

  @override
  Future<Result<int, Fail>> register(CreditCard card, User user) async {
    final cardCreateResult = await cardRepository.create(card, user);

    if (cardCreateResult.isError()) {
      return cardCreateResult;
    }

    return invoiceRepository.generateOfCard(card);
  }

  @override
  Future<Result<Unit, Fail>> update(CreditCard newCard) =>
      cardRepository.update(newCard);

  @override
  Future<Result<List<CreditCard>, Fail>> getAll(User user) async {
    var cards = await cardRepository.getAll(user);

    return cards;
  }

  @override
  Future<Result<Unit, Fail>> syncCard({
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
  Future<Result<Unit, Fail>> cancel(CreditCard card) =>
      cardRepository.delete(card);
}
