import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/credit_card_model.dart';

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
  Future<Result<List<CreditCardModel>, Fail>> getAll() async {
    var cards = await cardRepository.getAll();

    return cards.map((success) {
      List<CreditCardModel> models = [];
      for (var card in success) {
        models.add(
          CreditCardModel.fromEntity(card, castValue: 150.52 * card.id),
        );
      }

      return models;
    });
  }

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
