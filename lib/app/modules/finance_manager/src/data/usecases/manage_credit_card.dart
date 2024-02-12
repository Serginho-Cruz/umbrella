import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/imanage_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/icredit_card_repository.dart';
import '../repositories/iinvoice_repository.dart';

class ManageCreditCard implements IManageCreditCard {
  final ICreditCardRepository cardRepository;
  final IInvoiceRepository invoiceRepository;

  ManageCreditCard({
    required this.cardRepository,
    required this.invoiceRepository,
  });

  @override
  Future<Result<void, Fail>> register(CreditCard card) async {
    final cardCreateResult = await cardRepository.create(card);

    if (cardCreateResult.isError()) {
      return cardCreateResult;
    }

    return invoiceRepository.generateOfCard(card);
  }

  @override
  Future<Result<void, Fail>> update(CreditCard newCard) =>
      cardRepository.updateCard(newCard);

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() => cardRepository.getAll();

  @override
  Future<Result<void, Fail>> syncCard({
    required CreditCard cardToSync,
    required CreditCard cardToDelete,
  }) async {
    final createCard = await cardRepository.create(cardToSync);

    if (createCard.isError()) return createCard;

    final changeCardFromInvoices =
        await invoiceRepository.changeInvoicesFromCard(
      originCard: cardToSync,
      destinyCard: cardToDelete,
    );

    if (changeCardFromInvoices.isError()) return changeCardFromInvoices;

    return cardRepository.delete(cardToDelete);
  }

  @override
  Future<Result<void, Fail>> cancel(CreditCard card) =>
      cardRepository.delete(card);
}
